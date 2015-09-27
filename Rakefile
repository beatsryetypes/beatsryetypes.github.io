require 'yaml'
require 'time'
require 'mp3info'
require 'soundcloud'
require 'redcarpet'


MP3_DIR = File.expand_path(File.join('~', 'Dropbox', 'beatsryetypes', 'finished mp3s'))


task :new_ep, [:name] do |t, args|
  name = args[:name]
  now = Time.now
  this_coming_monday = now + ((1 - now.wday) * 60 * 60 * 24)
  timestamp = this_coming_monday.strftime('%Y-%m-%d') 
  most_recent = Dir['_posts/*.md'].sort.last
  last_episode_num = most_recent.match(/episode-(\d+)/)[1].to_i
  ep_num = last_episode_num + 1
  new_filename = "_posts/#{timestamp}-episode-#{ep_num}-#{name.downcase.gsub(/ /, '-')}.md"
  new_data = YAML.load_file(most_recent)
  stats = File.stat(mp3_path(ep_num))
  duration = ""
  Mp3Info.open(mp3_path(ep_num)) do |info|
    duration = "%d:%d" % [info.length / 60, info.length % 60]
  end
  new_data['title'] = "Episode #{ep_num}: #{name}"
  new_data['date'] = "#{timestamp} 08:15"
  new_data['link'] = "http://d5e3yh7f757go.cloudfront.net/eps/#{mp3_filename(ep_num)}"
  new_data['length'] = stats.size
  new_data['duration'] = duration
  File.open(new_filename, 'w') {|f| f << YAML.dump(new_data) }
end

task :migrate_to_soundcloud, [:post] do |t,args|
  migrate_to_soundcloud(args[:post])
end

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
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
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
