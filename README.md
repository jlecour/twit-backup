Twit-backup ![Project Status](http://stillmaintained.com/jlecour/twit-backup.png)
===========

Twit-backup is a little script, written in Ruby, to backup a user's Twitter timeline.

It is using OAuth to authenticate against the Twitter API, so you won't have to write down your login/password.

Installation
============

It only depends on a single external gem, [Twitter](http://github.com/jnunemaker/twitter/) by John [Nunemaker](http://railstips.org/). It also needs to require some Standard Libraries, but they are shipped with Ruby.

To install the Twitter gem, you just need to :

  gem install twitter
  

Configuration
=============

The first time, you have to execute the setup script, in order to get your OAuth tokens from the Twitter API

    ruby setup.rb

It is going to get the OAuth URL and open it in your browser. There you'll have to allow Twit-backup to access your timeline. Then it's going to give you a PIN code. You have to copy/paste it in your Terminal window.

If the authentication process is OK, you'll see a few of you last tweets. It means that the tokens are OK. You can execute the backup script at will.

By default the backup file if written in ~/twit-backup/timeline.txt along with an hidden file to remember the last saved tweet.

Execution
=========

To backup the last 200 tweets in your timeline, you just have to execute the backup script

    ruby backup.rb

It will download the tweets and write them into the backup file. If this backup file exceeds 1 MB, it is rotated and a new file is created.

Remember that you have a rate limit with the Twitter API, so don't execute the backup script too often. Once an hour seems to be a good rate, at least if you don't have more than 200 tweets in an hour.


Credits
=======

This script is highly inspired by John Nunemaker's examples from his gem.

It was also motivated by [Gregory Colpart's Perl script](http://github.com/gcolpart/twitter-backup/) to do the same job. But since I don't like Perl, and especially the tons of dependencies for the Twitter module, I wanted to have a pure Ruby implementation.
