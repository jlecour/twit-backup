require 'rubygems'
require 'twitter'
require 'pp'
require 'config_store'

config = ConfigStore.new("#{ENV['HOME']}/.twitter")
oauth = Twitter::OAuth.new(config['token'], config['secret'])

if config['atoken'] && config['asecret']
  oauth.authorize_from_access(config['atoken'], config['asecret'])
  twitter = Twitter::Base.new(oauth)
  pp twitter.friends_timeline
  
elsif config['rtoken'] && config['rsecret']  
  oauth.authorize_from_request(config['rtoken'], config['rsecret'])
  twitter = Twitter::Base.new(oauth)
  pp twitter.friends_timeline
  
  config.update({
    'atoken'  => oauth.access_token.token,
    'asecret' => oauth.access_token.secret,
  }).delete('rtoken', 'rsecret')
else
  puts "> redirecting you to twitter to authorize..."
  %x(open #{oauth.request_token.authorize_url})

  print "> what was the PIN twitter provided you with? "
  pin = gets.chomp  
  
  rtoken  = oauth.request_token.token
  rsecret = oauth.request_token.secret
  
  begin
    oauth.authorize_from_request(rtoken, rsecret, pin)
  
    config.update({
      'atoken'  => oauth.access_token.token,
      'asecret' => oauth.access_token.secret,
    }).delete('rtoken', 'rsecret')
  
    twitter = Twitter::Base.new(oauth)
    twitter.user_timeline.each do |tweet|
      puts "#{tweet.user.screen_name}: #{tweet.text}"
    end
  rescue OAuth::Unauthorized
    puts "> FAIL!"
  end
end