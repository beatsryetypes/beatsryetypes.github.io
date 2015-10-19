require 'yaml'
require 'time'

require 'bundler'
Bundler.require

MP3_DIR = File.expand_path(File.join('~', 'Dropbox', 'beatsryetypes', 'finished mp3s'))
S3_BUCKET = 'beatsryetypes'


class Episode
  attr_accessor :ep_num, :title

  def initialize(ep_num: nil, title: "")
    self.ep_num = ep_num.to_i
    self.title  = title
  end

  def process!
    filename = write_new_markdown
    copy_mp3_info
    upload_to_s3
  end

  def write_new_markdown
    now = Time.now
    this_coming_monday = now + ((1 - now.wday) * 60 * 60 * 24)
    timestamp = this_coming_monday.strftime('%Y-%m-%d') 
    most_recent = Dir['_posts/*.md'].sort.last
    new_filename = "_posts/#{timestamp}-episode-#{ep_num}-#{title.downcase.gsub(/ /, '-')}.md"
    new_data = YAML.load_file(most_recent)
    stats = File.stat(mp3_path)
    info = mp3_info
    duration = "%d:%d" % [info.length / 60, info.length % 60]
    new_data['title'] = "Episode #{ep_num}: #{title}"
    new_data['date'] = "#{timestamp} 08:15"
    new_data['link'] = "http://d5e3yh7f757go.cloudfront.net/eps/#{mp3_filename}"
    new_data['length'] = stats.size
    new_data['duration'] = duration
    File.open(new_filename, 'w') {|f| 
      f << YAML.dump(new_data) 
      f << <<-EOT
---
<!-- more -->

### Links, etc

* <strong>Music</strong>: Blah "Blah", Chosen by Blah. [Spotify](https://open.spotify.com/track/2JCwgae629iqLMSe67mR9z)

EOT
    }
    new_filename
  end

  def mp3_filename
    "brt-#{"%03d" % ep_num}-160.mp3"
  end

  def mp3_path
     File.join(MP3_DIR, mp3_filename)
  end

  def mp3_info
    Mp3Info.new(mp3_path)
  end

  def copy_mp3_info
    last_mp3_info = Episode.new(ep_num: ep_num - 1).mp3_info
    new_mp3_info = mp3_info

    fields_to_copy = %w{APIC TALB TPE1}
    new_title = "Beats, Rye & Types - Episode #{ep_num} - #{title}"
    new_mp3_info.tag.title = new_title
    fields_to_copy.each do |f|
      new_mp3_info.tag2[f] = last_mp3_info.tag2[f]
    end
    new_mp3_info.tag.tracknum = ep_num
    new_mp3_info.tag.year = Time.now.year
    new_mp3_info.close
  end

  def upload_to_s3
    puts "Uploading to S3"
    s3 = Aws::S3::Resource.new(region: 'us-east-1')
    obj = s3.bucket(S3_BUCKET).object("eps/#{mp3_filename}")
    obj.upload_file(mp3_path, acl:'public-read')
    puts "Upload #{obj.public_url}"
  end

end

def migrate_to_soundcloud(post_path)
  _, frontmatter, post = File.read(post_path).split('---')
  post_data = YAML.load(frontmatter)
  ep_num = post_path.match(/episode-(\d+)/)[1].to_i
  episode = Episode.new(ep_num: ep_num)
  id = upload_to_soundclound(
    mp3_path: episode.mp3_path,
    title: post_data['title'],
    description: post_data['summary'],
    tag_list: post_data['tag_list'],
    release_time: Time.parse(post_data['date']),
    release: ep_num
  )
  post_data['soundcloud'] = id
  File.open(post_path, 'w') {|f| 
    f << YAML.dump(post_data)
    f << "---"
    f << post
  }
end

def soundcloud_client
  @soundcloud_client ||= SoundCloud.new({
    :client_id     => ENV['SOUNDCLOUD_CLIENT_ID'],
    :client_secret => ENV['SOUNDCLOUD_CLIENT_SECRET'],
    :username      => ENV['SOUNDCLOUD_USERNAME'],
    :password      => ENV['SOUNDCLOUD_PASSWORD']
  })
end

def upload_to_soundclound(mp3_path: "", title: "", description: "", tag_list: "", release: "", release_time: Time.now)
  client = soundcloud_client
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  puts "Posting #{mp3_path}"
  track_params = {
    :title      => title,
    :description => markdown.render(description),
    :asset_data => File.new(mp3_path),
    :genre => "Podcast",
    :tag_list => tag_list,
    :release => release, #episode #
    :release_day => release_time.day,
    :release_month => release_time.month,
    :release_year => release_time.year,
    :track_type => "podcast",
    :downloadable => true,
    :commentable => true,
    :license => "cc-by",
    :sharing => "private"
  }
  puts track_params
  track = client.post('/tracks', :track => track_params)
  # print new tracks link
  puts "Uploaded to #{track.permalink_url}"
  track.id
end

