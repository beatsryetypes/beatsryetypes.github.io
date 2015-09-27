require './brt'

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

