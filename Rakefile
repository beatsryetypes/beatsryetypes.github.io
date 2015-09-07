require 'yaml'
require 'mp3info'

task :new_ep, [:name] do |t, args|
  file_dir = File.expand_path(File.join('~', 'Dropbox', 'beatsryetypes', 'finished mp3s'))
  name = args[:name]
  now = Time.now
  this_coming_monday = now + ((1 - now.wday) * 60 * 60 * 24)
  timestamp = this_coming_monday.strftime('%Y-%m-%d') 
  most_recent = Dir['_posts/*.md'].sort.last
  last_episode_num = most_recent.match(/episode-(\d+)/)[1].to_i
  ep_num = last_episode_num + 1
  new_filename = "_posts/#{timestamp}-episode-#{ep_num}-#{name.downcase.gsub(/ /, '-')}.md"
  new_data = YAML.load_file(most_recent)
  mp3_filename = "brt-0#{ep_num}-160.mp3"
  mp3_path = File.join(file_dir, mp3_filename)
  puts mp3_path
  stats = File.stat(mp3_path)
  duration = ""
  Mp3Info.open(File.open(mp3_path, 'rb')) do |info|
    duration = "%d:%d" % [info.length / 60, info.length % 60]
  end
  new_data['title'] = "Episode #{ep_num}: #{name}"
  new_data['date'] = "#{timestamp} 08:15"
  new_data['link'] = "http://d5e3yh7f757go.cloudfront.net/eps/#{mp3_filename}"
  new_data['length'] = stats.size
  new_data['duration'] = duration
  File.open(new_filename, 'w') {|f| f << YAML.dump(new_data) }
end
