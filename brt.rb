require 'yaml'
require 'time'

require 'bundler'
Bundler.require

MP3_DIR = File.expand_path(File.join('~', 'Dropbox', 'beatsryetypes', 'finished mp3s'))
S3_BUCKET = 'beatsryetypes'

def migrate_to_soundcloud(post_path)
  post_data = YAML.load_file(post_path)
  ep_num = post_path.match(/episode-(\d+)/)[1].to_i
  upload_to_soundclound(
    mp3_path: mp3_path(ep_num),
    title: post_data['title'],
    description: post_data['summary'],
    release_time: Time.parse(post_data['date']),
    release: ep_num
  )
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
    :license => "cc-by",
    :sharing => "private"
  }
  puts track_params
  track = client.post('/tracks', :track => track_params)
  # print new tracks link
  puts "Uploaded to #{track.permalink_url}"
  track.permalink_url
end

def mp3_filename(ep_num)
  "brt-#{"%03d" % ep_num}-160.mp3"
end

def mp3_path(ep_num)
   File.join(MP3_DIR, mp3_filename(ep_num))
end

def mp3_info(ep_num)
  Mp3Info.new(mp3_path(ep_num))
end

def copy_mp3_info(ep_num, title)
  last_mp3_info = mp3_info(ep_num - 1)
  new_mp3_info = mp3_info(ep_num)

  new_title = "Beats, Rye & Types - Episode #{ep_num} - #{title}"
  new_mp3_info.tag2 = last_mp3_info.tag2
  new_mp3_info.tag.title = new_title
  new_mp3_info.tag.tracknum = ep_num
  new_mp3_info.tag.year = Time.now.year
  new_mp3_info.close
end

def upload_to_s3(ep_num)
  s3 = Aws::S3::Resource.new(region: 'us-east-1')
  obj = s3.bucket(S3_BUCKET).object("eps/#{mp3_filename(ep_num)}")
  obj.upload_file(mp3_path(ep_num), acl:'public-read')
end
