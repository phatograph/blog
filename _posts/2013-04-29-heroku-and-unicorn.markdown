---
layout: post
title: "Heroku and Unicorn"
tags:
- Heroku
---

Yeah that rainbow Unicorn. I want to blog this for a while but I was too lazy.
I have been using [Unicorn](http://unicorn.bogomips.org/) since I built
my own VPS, [AppWaker](http://appwaker-vps.phatograph.com/) got the first shot.
I also need concurrent connections on [Teeview](http://teeview.phatograph.com/)
as well, so I came across some [nice](http://blog.codeship.io/2012/05/06/Unicorn-on-Heroku.html)
[articles](https://blog.heroku.com/archives/2013/2/27/unicorn_rails).

Here is a sample of the Unicorn configuration:

{% highlight ruby %}
worker_processes 3
timeout 600
preload_app true

before_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end

  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    Resque.redis.quit
    Rails.logger.info('Disconnected from Redis')
  end

  sleep 1
end

after_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end

  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    Resque.redis = ENV['REDIS_URI']
    Rails.logger.info('Connected to Redis')
  end
end
{% endhighlight %}
