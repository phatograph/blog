---
layout: post
title: "Rails OAuth with Twitter"
tags:
---

It had been an eternal struggling with me and OAuth since forever.
I didn't fully get how it works before. I first had to deal with Twitter authentication when I created
Twlist (with [Node](https://github.com/phatograph/twlist) and also [Rails](https://github.com/phatograph/twlist-rails))
And later on I when created [Twit Media Grid](https://github.com/phatograph/mediagrid) I think I understand it a bit more.

But no, that was a mistake. And since then I haven't worked any on it anymore. So the knowledge eventually got lost in space.

Now fast-forward to the present day I had to work this very Twitter authentication again.
So I dug through my old code and realised those are not going to work. At least not production-ready for sure.
Well then, perhaps it's time to work on it properly.

Figured it would be too much pain [collecting parameter from scratch](https://developer.twitter.com/en/docs/basics/authentication/guides/authorizing-a-request)
and since I'm working on a Rails application so I just have a go with [Ruby OAuth](https://github.com/oauth-xx/oauth-ruby) gem. Here goes.

### 1. Create a Consumer object

A consumer object will be used to get a request token. According to Ruby OAuth, here's how to do so.

{% highlight ruby %}
OAuth::Consumer.new(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, {:site => "https://api.twitter.com"})
{% endhighlight%}

And since this object can be reuseable, we can make use of [Or Equals](http://www.rubyinside.com/what-rubys-double-pipe-or-equals-really-does-5488.html)
like this.

{% highlight ruby %}
class ApiController < ApplicationController
  CALLBACK_URL = "/login/callback"
  TWITTER_CONSUMER_KEY = ""
  TWITTER_CONSUMER_SECRET = ""

private

  def consumer
    @@consumer ||= OAuth::Consumer.new(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, {:site => "https://api.twitter.com"})
  end
end
{% endhighlight%}

Now that we have a Consumer, we can make a request to get an OAuth token.

### 2. Request for an OAuth token

To get an OAuth token, you'll need to create a Request token using `consumer.get_request_token`.
You'll also need to supply a callback URL within an object containing `:oauth_callback` as well.

At this point, dont' forget to add the URL to your Twitter app's Callback URL.

{% highlight ruby %}
class ApiController < ApplicationController
  CALLBACK_URL = "/login/callback"
  TWITTER_CONSUMER_KEY = ""
  TWITTER_CONSUMER_SECRET = ""

  def request_token
    _request_token = consumer.get_request_token(:oauth_callback => "#{params[:base_url]}#{CALLBACK_URL}")

    render json: {
      "request_token": _request_token.token,
      "request_secret": _request_token.secret,
      "request_token_url": _request_token.authorize_url(:oauth_callback => "#{params[:base_url]}#{CALLBACK_URL}"),
    }
  end

private

  def consumer
    @@consumer ||= OAuth::Consumer.new(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, {:site => "https://api.twitter.com"})
  end
end
{% endhighlight%}

A URL to Twitter's authorisation page will be generated from `_request_token.authorize_url` (with the same callback URL).
You can just redirect a user right away with it. But in my case there is some work to do
on the front-end too. So just ignore it and also the weird params stuff.

There are also two important values, `_request_token.token` and `_request_token.secret`, they both need to be kept
in order to recreate `_request_token` again in another action. So you can store them in Cookie, or session, your call.

Now with a URL generated from `_request_token.authorize_url`, you'll need to navigate a user to this URL, which is Twitter's authorisation page.
In the page, if they're not already logged in they'll need to fill in their credentials, then they'll be asked to authorise the app.

Finally they will be redirected back to your application callback URL, along with some query strings, one of them is `oauth_verifier`.

### 3. Request for an Access token

Since a user will be landed in another action (in this case, `ApiController#access_token`),
so access to `_request_token` from `ApiController#request_token` is lost.
We'll need to recreate it. Remember `_request_token.token` and `_request_token.secret` that you keep them?
They shall be at help here, along with `consumer` as a private method.

{% highlight ruby %}
_request_token = OAuth::RequestToken.from_hash(consumer, {
  oauth_token: params[:request_token_token],
  oauth_token_secret: params[:request_token_secret]
})
{% endhighlight%}

Almost there! Now we have the `_request_token` back, and also `oauth_verifier` from Twitter. We can make a request for an Access token.

{% highlight ruby %}
access_token = _request_token.get_access_token(oauth_verifier: params[:oauth_verifier])
{% endhighlight%}

And finally, Access token get! You can any further request to Twitter using this token as you like. It's all yours now.

To put it all together, the whole controller would look like this.

{% highlight ruby %}
class ApiController < ApplicationController
  CALLBACK_URL = "/login/callback"
  TWITTER_CONSUMER_KEY = ""
  TWITTER_CONSUMER_SECRET = ""

  def request_token
    _request_token = consumer.get_request_token(:oauth_callback => "#{params[:base_url]}#{CALLBACK_URL}")

    render json: {
      "request_token": _request_token.token,
      "request_secret": _request_token.secret,
      "request_token_url": _request_token.authorize_url(:oauth_callback => "#{params[:base_url]}#{CALLBACK_URL}"),
    }
  end

  def access_token
    _request_token = OAuth::RequestToken.from_hash(consumer, {
      oauth_token: params[:request_token_token],
      oauth_token_secret: params[:request_token_secret]
    })

    access_token = _request_token.get_access_token(oauth_verifier: params[:oauth_verifier])

    render json: access_token
  end

private

  def consumer
    @@consumer ||= OAuth::Consumer.new(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, {:site => "https://api.twitter.com"})
  end
end
{% endhighlight%}
