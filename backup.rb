require 'rubygems'
require 'twitter'
require 'config_store'
require 'time'
require 'fileutils'

def check_dir(dir)
  FileUtils.mkdir_p(dir) unless File.directory?(dir)
end

def rotate_file_if_too_big(file, max_size = nil)
  return unless max_size.to_i > 0
  if File.exists?(file) && File.size(file) > max_size
    File.rename file, file.gsub(/\.([^\.]+)$/, ".#{Time.now.to_i}.\\1")
  end
end

def format_tweet(tweet)
  res = []
  res << Time.parse(tweet.created_at).strftime('%Y-%d-%m %T')
  res << tweet.user.screen_name
  res << tweet.text
  res << '[' + tweet.id.to_s + ']'
  res.join(' ')
end

base_dir = File.expand_path File.join('~', 'Documents', 'twit-backup')
check_dir(base_dir)
backup_file = File.join(base_dir, 'timeline.txt')
lastid_file = File.join(base_dir, '.lastid')

config = ConfigStore.new("#{ENV['HOME']}/.twitter")

oauth = Twitter::OAuth.new(config['token'], config['secret'])
oauth.authorize_from_access(config['atoken'], config['asecret'])

twitter = Twitter::Base.new(oauth)

lastid = File.readlines(lastid_file)[0].split.first.to_i rescue nil

rotate_file_if_too_big backup_file, 10*1024*1024

options = {}
options[:count] = 200
options[:since_id] = lastid if lastid.to_i > 0

File.open(backup_file, 'a') do |f|
  unless (tweets = twitter.friends_timeline(options)).empty?
    tweets.reverse.each do |tweet|
      f.puts format_tweet(tweet)
    end
    File.open(lastid_file, "w") { |f| f.puts tweets.max_by(&:id).id }
  end
end
