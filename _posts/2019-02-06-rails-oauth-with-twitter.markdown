---
layout: post
title: "Rails OAuth with Twitter"
tags:
- rails
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

A Consumer object will be used to get both OAuth token and Access token. To create it, according to Ruby OAuth, here's how to do so.

<pre><code class="language-ruby">
OAuth::Consumer.new(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, {:site => "https://api.twitter.com"})
</code></pre>

And since this object is reuseable, we can make use of [Or Equals](http://www.rubyinside.com/what-rubys-double-pipe-or-equals-really-does-5488.html)
and put it in a controller like this.

<pre data-line="8-10"><code class="language-ruby">
class ApiController < ApplicationController
  CALLBACK_URL = "/login/callback"
  TWITTER_CONSUMER_KEY = ""
  TWITTER_CONSUMER_SECRET = ""

private

  def consumer
    @@consumer ||= OAuth::Consumer.new(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, {:site => "https://api.twitter.com"})
  end
end
</code></pre>

Now that we have a Consumer, we can use it to make a request to get an OAuth token.

### 2. Getting a request token

At this point, dont' forget to add the URL to your Twitter app's Callback URL.

To get a request token, you'll to make a request using `consumer.get_request_token`.
You'll also need to supply a callback URL within an object containing `:oauth_callback` as well.

<pre data-line="7"><code class="language-ruby">
class ApiController < ApplicationController
  CALLBACK_URL = "/login/callback"
  TWITTER_CONSUMER_KEY = ""
  TWITTER_CONSUMER_SECRET = ""

  def request_token
    _request_token = consumer.get_request_token(:oauth_callback => "#{params[:base_url]}#{CALLBACK_URL}")

    session[:request_token] = _request_token.token,
    session[:request_secret] = _request_token.secret,

    redirect_to _request_token.authorize_url(:oauth_callback => "#{params[:base_url]}#{CALLBACK_URL}"),
  end

private

  def consumer
    @@consumer ||= OAuth::Consumer.new(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, {:site => "https://api.twitter.com"})
  end
end
</code></pre>

There are two important values, `_request_token.token` and `_request_token.secret`, they both need to be kept
in order to recreate `_request_token` again in another action. So you can store them in Cookie, or session, your call.

Now with a URL generated from `_request_token.authorize_url`, you'll need to navigate a user to this URL, which is Twitter's authorisation page.
In the page, if they're not already logged in they'll need to fill in their credentials, then they'll be asked to authorise the app.

Finally they will be redirected back to your application callback URL, along with some query strings, one of them is `oauth_verifier`.

### 3. Getting an Access token

Since a user will be landed in another action (in this case, `ApiController#access_token`),
so access to `_request_token` from `ApiController#request_token` is lost.
We'll need to recreate it. Remember `_request_token.token` and `_request_token.secret` that you keep them?
They shall be at help here, along with `consumer` as a private method.

<pre><code class="language-ruby">
_request_token = OAuth::RequestToken.from_hash(consumer, {
  oauth_token: params[:request_token_token],
  oauth_token_secret: params[:request_token_secret]
})
</code></pre>

Almost there! Now we have the `_request_token` back, and also `oauth_verifier` from Twitter. We can make a request for an Access token
using `_request_token.get_access_token`.
You'll also need to supply an OAuth verifier within an object containing `:oauth_verifier` as well.

<pre data-line="16-19,21"><code class="language-ruby">
class ApiController < ApplicationController
  CALLBACK_URL = "/login/callback"
  TWITTER_CONSUMER_KEY = ""
  TWITTER_CONSUMER_SECRET = ""

  def request_token
    _request_token = consumer.get_request_token(:oauth_callback => "#{params[:base_url]}#{CALLBACK_URL}")

    session[:request_token] = _request_token.token
    session[:request_secret] = _request_token.secret

    redirect_to _request_token.authorize_url(:oauth_callback => "#{params[:base_url]}#{CALLBACK_URL}"),
  end

  def access_token
    _request_token = OAuth::RequestToken.from_hash(consumer, {
      oauth_token: session[:request_token],
      oauth_token_secret: session[:request_secret],
    })

    access_token = _request_token.get_access_token(oauth_verifier: params[:oauth_verifier])

    render json: access_token
  end

private

  def consumer
    @@consumer ||= OAuth::Consumer.new(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, {:site => "https://api.twitter.com"})
  end
end
</code></pre>

And finally, Access token get! You can any further request to Twitter using this token as you like. It's all yours now.
