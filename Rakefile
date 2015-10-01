require './brt'

task :new_ep, [:ep_num, :title] do |t, args|
  Episode.new(ep_num: args[:ep_num], title: args[:title]).process!
end

task :migrate_to_soundcloud, [:post] do |t,args|
  migrate_to_soundcloud(args[:post])
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
