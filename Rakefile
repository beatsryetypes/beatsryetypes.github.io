require './brt'

desc 'Generate a new ep: rake new_ep[num, title]'
task :new_ep, [:ep_num, :title] do |t, args|
  Episode.new(ep_num: args[:ep_num], title: args[:title]).process!
end

desc 'Upload an ep to soundcloud: rake migrate_to_soundcloud["_posts/..."]'
task :migrate_to_soundcloud, [:post] do |t,args|
  migrate_to_soundcloud(args[:post])
end

desc 'Create a new tip entry: rake new_tip["tip name","photo path.jpg"]'
task :new_tip, [:name, :image_path] do |t, args|
  new_tip(args[:name], args[:image_path])
end

desc 'Create a new tip entry, but for todays date'
task :new_tip_today, [:name, :image_path] do |t, args|
  new_tip(args[:name], args[:image_path], Time.now)
end

desc 'New News article'
task :new_news, [:name] do |t, args|
  new_news(args[:name])
end

desc 'send a post to twitter via buffer'
task :buff, [:post_path] do |t, args|
  buff(args['post_path'])
end

desc 'send latest post to twitter via buffer'
task :buff_latest do |t|
  buff(Dir["_posts/*tip*"].sort_by{|f| File.mtime(f) }.last)
end

task :migrate_all_to_soundcloud do
  Dir.glob('_posts/*.md') do |post|
    begin
      puts "[#{Time.now}] #{post}"
      migrate_to_soundcloud(post)
    rescue => e
      puts e
      puts e.backtrace
      puts "-------"
    end
  end
end
