task :new_ep, [:name] do |t, args|
  name = args[:name]
  now = Time.now
  this_coming_monday = now + ((1 - now.wday) * 60 * 60 * 24)
  timestamp = this_coming_monday.strftime('%Y-%m-%d') 
  most_recent = Dir['_posts/*.md'].sort.last
  last_episode_num = most_recent.match(/episode-(\d+)/)[1].to_i
  new_filename = "_posts/#{timestamp}-episode-#{last_episode_num + 1}-#{name.downcase.gsub(/ /, '-')}.md"
  cp(most_recent, new_filename)
  new_data = YAML.load(new_filename)
  new_data['title'] = "Episode #{last_episode_num + 1}: #{name}"
  new_data['date'] = "#{timestamp} + 08:15"
end
