---
layout: post
title: "\"What's your proudest achievement?\""
tags:
- self
---

I was asked this question in an interview. I have created many pet projects
so far, many that I liked and each has its own special charm, because these
projects are generally to test new skills I'm interested in. But it
did not take me long to realise my proudest one was Teeview.

<p class="image-c">
  <img src="/assets/images/teeview00.png" style="width: 500px" />
  <span>Teeview as on February 19th, 2016.</span>
</p>

### Teeview was born!

[Teeview](http://www.teeview.org) is an index or catalog web site
which gathers t-shirt campaigns of [Teespring](https://teespring.com)
and displays them altogether. For some reason Teespring decides not to
have this 'all campaigns' page themselves, and that has been the reason
why Teeview exists.

> Teeview originally was created solely for my own use.

I created Teeview on March 13th, 2013 (first commit). Back on that time I just knew
about Teespring and would like to join some campaigns. But there
were not so many campaigns shown on Teespring, so I had an idea to gather
these campaigns from Google and Twitter, so I could take a look and
join some.

### Teeview met Teespring

A week after launching Teeview I tweeted the guys at
Teespring to let them know that I was
stalking and scraping their site, so if they don't like it I
could shut it down. But they seemed to be happy.

<p class="image-c">
  <img src="/assets/images/teeview01.png" style="width: 500px" />
  <span>Sadly I could not find the embedded version anymore. This was from my email.</span>
</p>

They even helped me promoting Teeview by retweeting and mentioning
many times in their Twitter. Thus some people started using Teeview.

### People wanted their campaigns up!

I usually got emails from users saying they liked my site and
they would like their campaigns to be displayed too. Since Teeview uses
an automated rake task to add campaigns, that time I needed
to do this manual campaign adding via the rails console.
Obviously not an efficient way but it just worked that time, with not
so many requests.

September 2013, six months after launching, Teeview's campaigns
almost reached 10,000 records, which is the limit of [Heroku's
Postgres free plan](https://www.heroku.com/pricing).
I then decided to rent an external server for hosting a database.
Now there was a maintenance cost I need to cover.
Therefore one month later I placed a paypal donation link.
And my users helped me a lot! I could keep Teeview running without
any financial problem.

### But people also wanted their campaigns hidden ...

I still had been regularly getting emails from users, but at the end of
2013, users started to ask me to hide their campaigns. It turned out
that there were people using Teeview to look for popular campaigns ...
and *copy* them. I did take this as a serious matter and immediately
granted their requests. Well, still using rails console, though.

This kind of requests got more frequent,
and the ones for adding new campaigns
still kept coming. I got tired of the manual
console work. So I decided to implement the solution
to this properly, by adding a membership system.

### Teeview had registered users!

January 13th, 2014, I shipped the membership system for Teeview,
allowing registered users to directly add their campaigns, and also
request to hide their campaigns (or so called archive).

<p class="image-c">
  <img src="/assets/images/teeview02.png" style="width: 500px" />
  <span>Teeview user's campaigns management page.</span>
</p>

The way campaign archiving works is first the user requests for
archiving, and the requested campaigns show up in the admin panel,
but at this time even without approval they are already hidden.
The approval is just that I want to have a quick glance what is
being requested. I would just accept right away.

This self-campaigns management went very well and all email requests
were gone in couple of weeks.

### Teeview Facebook page

As another channel to reach out users I created a [Facebook page
for Teeview](https://www.facebook.com/teeviewofficial/) on
February 12, 2014. It gradually has gained more likes since then.

<p class="image-c">
  <img src="/assets/images/teeview03.png" style="width: 500px" />
</p>

By using the page I can announce some changes and easily run some surveys.
Also some users would message me if they have
any question or something goes wrong in Teeview, so that I could
fix it promptly.

### Teeview met Teespring #2

It's been a while and Teespring said Hi to me again,
this time I was introduced to Walker Williams,
the co-founder and CEO himself! I was very pleased and honoured
that they cared and reached out to me. We discussed about
protecting Teespring's power sellers from copycats. I agreed
and was more than happy to implement a rule to check a *hidden variable*
on upcoming campaigns and opt them out from displaying
on Teeview.

> "I wanted to make sure we told you first as you're the first one we want on our white list!"
> – Teespring

They were so kind and generous and they donated (a lot)
to help Teeview running, thanks a lot Teespring folks!

### From donation to advertisement

In mid 2014 I got a European scholarship and decided to quit
my job and study a master's abroad. With a lot of users having
already donated (thanks a lot again, guys) it's pretty
normal that funding this way is going to fade out sooner
or later. And now that I didn't have a salary anymore,
I rolled out a survey to ask if the users were willing to
pay for a monthly subscription, which I thought it could be around
$1.99 or $2.99.

For a couple months of surveying, around 200 users were willing
to pay. But in my mind I always wanted to keep the service free.
And I was so busy with the university stuff, I simply stalled the plan.

Luckily, in May 2015, I was contacted by [TeeSpy](https://teespy.com/),
which also does a great job in campaign informations, asking to be a partner.
I decided to cooperate with this awesome people, and since then
Teeview has had their advertisement banner flag flying high up in the right.
And thanks to them that solved the Teespring financial problem.

### All the great moments, now to the sunset ...

<p class="image-c">
  <img src="/assets/images/teeview04.png" style="" />
</p>

From its glorious days in 2014 to its
down road in late 2015, to me it has been so long.
Teeview is the first project that made me interact with real users (all over the world!)
and real companies. Solving user cases. Negotiating and doing
some actual businesses. Making
[some](https://www.shopify.com/blog/14515425-how-to-start-an-online-t-shirt-business-the-ultimate-guide)
[impact](http://cloudincome.com/make-over-400-week/) out there.
It has been an unbelievably outstanding experience from which I learned a lot.

<p class="image-c">
  <img src="/assets/images/teeview05.png" style="" />
  <span>Users from all over the world!</span>
</p>

Considering from the graph that less users are using Teeview,
perhaps it's time to call it a day. But there's always tomorrow!
I believe Teeview needs a rewrite and reengineering, to be
better in both performance and appearance. I will do my best
to keep it running good and adapt it to match nowadays usage.
Teeview shall rise again!

Lastly, it's been my pleasure to be able to create a project
that has been and will be used by many people. I would like to thank you all.
You all make me so happy. All the best and thank you!
