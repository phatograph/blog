---
layout: post
title: "Heroku and Travis"
tags:
- Heroku
- Travis
---

The story was this, I would like to have a CI to get my code from GitHub,
maybe run some test, and deploy it to Heroku. So I could commit to one place
(`master`) and everything would be set up. Travis is very handy in this,
but require some configurations.

Well I've covered most of my Travis knowledge on [previous post](/articles/2013/04/26/heroku-and-unicorn/)
so there's nothing much here. Let's see my configuration for the upcoming [phatograph2013](https://github.com/phatograph/phatograph2013)
then.

{% highlight ruby %}
---
rvm:
- 1.9.3
after_script:
- if [[ "$TRAVIS_BRANCH" != "master" ]]; then exit 0; fi
- wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
- git remote add heroku git@heroku.com:phatograph2013.git
- echo "Host heroku.com" >> ~/.ssh/config
- echo "   StrictHostKeyChecking no" >> ~/.ssh/config
- echo "   CheckHostIP no" >> ~/.ssh/config
- echo "   UserKnownHostsFile=/dev/null" >> ~/.ssh/config
- heroku keys:clear
- yes | heroku keys:add
- yes | git push heroku master
env:
  global:
  - secure: ! 'FZ4Os+3zidYERHmdesrifZO47XGy7jOfH4v/wbYofbRhLQJUwplQHFVF6aHi
{% endhighlight %}

This build came up from [many](http://xseignard.github.io/2013/02/18/continuous-deployement-with-github-travis-and-heroku-for-node.js/)
[really](http://stackoverflow.com/questions/10235026/how-to-deploy-an-rails-app-on-heroku-from-travis-ci)
[nice](http://metabates.com/2012/10/23/deploying-to-heroku-from-travisci/)
[posts](http://www.neilmiddleton.com/deploying-to-heroku-from-travis-ci/).
I would like to thank them all here. The trick, is you need to encrypt your Heroku API key.

{% highlight bash %}
$ travis encrypt HEROKU_API_KEY=<your_heroku_key> --add
{% endhighlight %}

The command would generate a `secure:` property. Another note at this line:

{% highlight bash %}
- if [[ "$TRAVIS_BRANCH" != "master" ]]; then exit 0; fi
{% endhighlight %}

I have the CI perform only commits to `master`, so the feature branch
commits won't trigger the code deployment.

And because I don't have any test suite for this site. So I have to let
the rake run nothing

{% highlight bash %}
#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Phatograph2013::Application.load_tasks

task :default => []
{% endhighlight %}
