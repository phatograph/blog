---
layout: post
title: "\"What's your proudest achievement?\""
tags:
---

I was asked this question in an interview. I have created many pet projects
so far, many that I liked and each has its own special. Because these
projects are generally to test new skills I'm interested in. But it
did not take me long to realised my proudest one was Teeview.

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
were too less campaigns shown on Teespring, so I had an idea to gather
these campaigns from Google and Twitter, so I could take a look and
join some.

### Teeview met Teespring

A week after launched Teeview I tweeted the guys at
Teespring to let them knew that I was
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
they wished their campaigns to be displayed also. Since Teeview uses
an automated rake task to add campaigns, that time I needed
to do this manual campaign adding via a rails console.
Obviously not an efficient way but it just worked that time, with not
so many requests.

September 2013, six months after launching, Teeview's campaigns
almost reached 10,000 records, which is a limit of [Heroku's
Postgres free plan](https://www.heroku.com/pricing).
I then decided to rent an external VPS for hosting a database.
Now there was a maintenance cost I need to cover.
Therefore one month later I placed a paypal donation link.
And my users helped me a lot! I could keep Teeview running without
any financial problem.

### But people also wanted their campaigns hidden ..

I had been regularly got emails from users, but at the end of
2013, users started to ask me to hide their campaigns. It turned out
that there were people used Teeview to look for popular campaigns ..
and *copy* them. I did take this as a serious matter and immediately
granted their requests. Well, still using rails console, though.

This kind of requests got more frequent, along with the add campaigns
requests which still kept coming, which I got tired of the labour
console work. So I decided to implement the solution
to this properly, by adding a membership system.

### Teeview had registered users!

January 13th, 2014 I shipped the membership system for Teeview,
allowing registered users to directly add their campaigns, and also
request to hide, or so called archive, their campaigns.

<p class="image-c">
  <img src="/assets/images/teeview02.png" style="width: 500px" />
  <span>Teeview user's campaigns management page.</span>
</p>

The way campaign archiving works are first the user requested for
archiving, and the requested campaigns will shown up in admin panel,
but at this time even without approval they would have already been hidden.
The approval is just that I want to have a quick glance what are
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

By using the page I can announce some changes and run some survey
more easily. Also some users would message me if they have
any question for something goes wrong in Teeview, so that I could
fix it promptly.

### Teeview met Teespring #2

It's been a while and Teespring said Hi too me again,
this time I was introduced to Walker Williams,
the co-founder and CEO himself! I was very pleased and honoured
that they cared and reached me out. We discussed about
protecting Teespring's power sellers from copycats. I agreed
and was more then happy to implement a rule to check a *hidden variable*
on upcoming campaigns and opt them out from displaying
on Teeview.

> "I wanted to make sure we told you first as you're the first one we want on our white list!"
> – Teespring

They were so kind and generous and they donated me (a lot)
to help Teeview running, thanks a lot Teespring folks!

### From donation to advertisement

In mid 2014 I got a European scholarship and decided to quit
my job and study master's aboard. With a lot of users
already donated me (thanks a lot again, guys) it's pretty
normal that funding this way is going to fade out sooner
or later, and now that I didn't have a salary anymore.
I rolled out a survey to ask if the users were willing to
pay for a monthly subscription, which I though it could be around
$1.99 to $2.99.

For a couple months of surveying, around 200 users were willing
to pay. But in my mind I always wanted to keep the service free.
And I was so busy with the university stuff, I simply stalled the plan.

Luckily, in May 2015, I was contacted by [TeeSpy](https://teespy.com/),
which also does a great job for campaign informations, to be a partner.
I decided to cooperate with this awesome people, and since then
Teeview has had their advertisement banner flag flying high up in the right.
And thanks to them that solved the Teespring financial problem.

### All the great moments, now to the sunset ..

<p class="image-c">
  <img src="/assets/images/teeview04.png" style="" />
</p>

From its glorious days in 2014 to its
down road in late 2015, to me it has been so long. Teeview is the first
project that made me interact with real users (all over the world!)
and real companies. It has been an unbelievably outstanding
experience that I learnt a lot.

<p class="image-c">
  <img src="/assets/images/teeview05.png" style="" />
  <span>Users from all over the world!</span>
</p>

Considering from the graph that less users are using Teeview,
Perhaps it will call it a day. But there's always tomorrow!
I believe it needs a rewritten and reengineering, to be
better in both performance and appearance. I will do my best
to keep it running good and evolve it to match nowadays usage.
Teeview shall rise again!

Lastly, it's been my pleasure to be able to create a project
that really being used by many people. I would like to thank you all.
You all make me so happy. All the best and thank you!
