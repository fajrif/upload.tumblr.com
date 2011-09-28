require 'yaml'
require 'feedzirra'
require 'pandoc-ruby'
require 'tumblr'

desc "Generate post from a given rss url in config/url.yaml"
task :generate do
  require './lib/titlecase.rb'
  config_yaml = YAML.load_file("config/url.yml")
  config_yaml.each do |url|
    feeds = Feedzirra::Feed.fetch_and_parse(url['rss'])
    unless feeds.nil?
      `mkdir posts` unless Dir.exists? "posts"
      feeds.sanitize_entries!
      feeds.entries.each do |entry|
        filename = "posts/#{entry.published.strftime('%Y-%m-%d')}-#{entry.title.to_filename}.markdown"
        mdown = PandocRuby.convert(entry.content, :from => :html, :to => :markdown)
        tags = entry.categories.empty? ? "uncategorized" : entry.categories.join(", ")
        
        puts "Creating new post: #{filename}"
        open(filename, 'w') do |post|
          post.puts "---"
          post.puts "title: \"#{entry.title}\""
          post.puts "date: #{entry.published.strftime('%Y-%m-%d %H:%M')}"
          post.puts "state: published"
          post.puts "tags: #{tags}"
          post.puts "---"
          post.puts
          post.puts mdown
        end
      end
    end
  end
end

desc "Publish all posts to tumblr.com"
task :publish do
  require './lib/monkey_patch.rb'
  if Dir.exists? "posts"
    config_yaml = YAML.load_file("config/credential.yml")
    user = Tumblr::User.new(config_yaml['email'], config_yaml['password'], false)
    Dir.glob("posts/*.markdown").each do |filename|
      post = Tumblr::Post.create(user, filename)
      puts "Publish to Tumblr.com post ID: <#{post}> filename:#{filename}"
    end
  else
    puts "Unable to find posts directory!"
  end
end

desc "Clear all generated posts in posts directory"
task :clear do
  `rm -rf posts/*`
  puts "All posts are destroyed!!"
end

