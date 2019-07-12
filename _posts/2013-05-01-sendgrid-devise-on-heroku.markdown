---
layout: post
title: "SendGrid + Devise on Heroku"
tags:
- heroku
- devise
---

Let's say I have a subdomain [devsheet.phatograph.com](http://devsheet.phatograph.com/) and I want to configure __SendGrid__ and __Devise__ in Heroku, here are things to be done.

### production.rb

Devise documentation and this [post](http://stackoverflow.com/questions/6019083/setting-up-devise-sendgrid-on-heroku) tell me to configure `config.action_mailer.default_url_options` as:

{% highlight ruby %}
config.action_mailer.default_url_options = { :host => 'devsheet.phatograph.com' }
{% endhighlight %}

And from Heroku Dev Center's [post](https://devcenter.heroku.com/articles/smtp#sending-email-from-rails):

{% highlight ruby %}
config.action_mailer.raise_delivery_errors = true
config.action_mailer.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address        => "smtp.sendgrid.net",
  :port           => "25",
  :authentication => :plain,
  :user_name      => ENV['SENDGRID_USERNAME'],
  :password       => ENV['SENDGRID_PASSWORD'],
  :domain         => ENV['SENDGRID_DOMAIN']
}
{% endhighlight %}

### devise.rb

From Devise's predefined configuration:

{% highlight ruby %}
config.mailer_sender = "noreply@devsheet.phatograph.com"
{% endhighlight %}
