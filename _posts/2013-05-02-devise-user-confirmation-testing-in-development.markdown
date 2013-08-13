---
layout: post
title: "Devise user confirmation testing in development"
tags:
- Devise
---

I want to test Devise's `confirmable` feature in local development, so I need
a way to locally send & receive emails. Got this technique from this [post](http://stackoverflow.com/questions/8186584/how-do-i-set-up-email-confirmation-with-devise).
I'd like to paste it here.

* Make sure you include confirmable in Model.devise call
* Make sure you add confirmable to the user migration
* Generate the devise views _(ps. I found that this step is unnecessary)_

{% highlight bash %}
$ rails generate devise:views
{% endhighlight %}

* Add the following config lines in `/config/environments/development.rb`

{% highlight ruby %}
config.action_mailer.default_url_options = { :host => 'localhost:3000' }
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {:address => "localhost", :port => 1025}
{% endhighlight %}

* To test the setup in development install the mailcatcher gem,
that you will use as a SMTP server in development, catching all incoming mails
and displaying them on [localhost:1080](http://localhost:1080/)

{% highlight bash %}
$ gem install mailcatcher
{% endhighlight %}

Once installed start the mailcatcher server with the command

{% highlight bash %}
$ mailcatcher
{% endhighlight %}

A toy SMTP server will be running on port 1025 catching and displaying emails on HTTP port 1080.
