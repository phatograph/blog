---
layout: post
title: "#AngelHackBKK"
tags:
---

<p style="text-align: center;">
  <img src="https://dl.dropbox.com/s/u9oyjchsyxpkcpf/2556-06-07_at_4.25.32_PM.png" style="width: 500px" />
</p>

I had a chance to attend a first time [AngelHack in Bangkok](http://www.hackathon.io/angelhack39)
arranged on [Sat 1 to Sun 2, June 2013](http://www.hackathon.io/angelhack39/schedules),
at the Bangkok University (Kluaynamthai campus).
It was a fun event. Many developers, designers and businesspersons
came to the event, around 70% are Thai and the rest are foreigners.

I got there around 10AM. People were still coming and registering.
Things then quite went along according to the [schedule](http://www.hackathon.io/angelhack39/schedules).

### The Pitching

<p style="text-align: center;">
  <img src="https://dl.dropbox.com/s/ri307x4d8dw50et/2556-06-07_at_4.32.27_PM.png" />
</p>

Teams that want to present themselves or need more members had
a chance to pitch to audiences. Each team has 2 (eh, or 4 ?) minutes to talk.
There were 5-6 teams did the pitch. One of them has a very interesting idea,
they would like to create a location-based money tracking app.

<blockquote class="twitter-tweet"><p><a href="https://twitter.com/search/%23AngelHackBKK">#AngelHackBKK</a> pitched my checkin expense tracking idea.Join me anyone?</p>&mdash; Bryan (@_bjb) <a href="https://twitter.com/_bjb/status/340693380277342208">June 1, 2013</a></blockquote>

Along with the pitching there were minigames awarding fun prices
(Nerf guns, rubrics, geeky stuffs). I didn't pitch since I thought
I would go for it by myself. But it always fun to watch.

After the pitching lunch was served. And the hackaton silently began.

### The Project

What I wanted to hack on is a web application that can search for
tweets nearby by a keyword. It would be nice if we could get tweets
that people are talking about traffic jam or raining. We
could know these event's locations. I named it [Twitmap](http://www.hackathon.io/twitmap).

I did some planning before. I would go for a Rails apps. Nice ol' friend [Gmap.js](http://hpneo.github.io/gmaps/)
for handling the Google Maps. And I would like to write my own Twitter API
wrapper class (later I named it [Poor man's Twitter](https://github.com/phatograph/twitmap/blob/master/app/models/poorman_twitter.rb)).
[Other stuffs](https://github.com/phatograph/twitmap/blob/master/Gemfile) are quite general.
All I need was just bring them on together and typing. Luckily
I got a company, [@rhearnorth](https://github.com/rhearnorth) was
helping me tackling down Twitmap. It was very nice working with him ;)

From Saturday 1PM we hackers begun each project. There was also
a sponsor talk session from a Blackberry guy but I didn't join.
Too busy on coding.

<p style="text-align: center;">
  <img src="https://dl.dropbox.com/s/b60w3cmj8pc61yu/2556-06-07_at_6.12.52_PM.png" style="width: 500px" />
</p>

We worked really hard.

<p style="text-align: center;">
  <img src="https://dl.dropbox.com/s/woxz928mwnc5x5a/2556-06-07_at_6.15.49_PM.png" style="width: 500px" />
</p>

### The Facilities

The event was arranged at BU's Gallery (BUG building, really nice place
to hack). The facilities were awesome, we have 3 rooms available for
24 hours, they were suppose to be a lounge at the 5th floor
(that's where gunfires happened), a lecture room and .. a theatre, on 6th floor.
We were coding at the lounge.

<p style="text-align: center;">
  <img src="https://dl.dropbox.com/s/qmehakdd79qtrew/2556-06-07_at_6.22.30_PM.png" style="width: 500px" />
</p>

One thing to note here is if you want to stay over night. Please
bring a sleeping bag or a blanket. BUG is painfully cold at night.
Moreover, despite a fact that BU is a University, I'd say that
BUG 5th floor has a perfect balcony to drink beers.

Oh, yes, food's great too. Even they're lunchboxes but ther're
really great ;)

### The Debate

After 14+ hours of work, Twitmap has been launched to the internet
for goods at __twitmap.herokuapp.com__ (later I mapped her to
[twitmap.phatograph.com](twitmap.phatograph.com))

<p style="text-align: center;">
  <img src="https://dl.dropbox.com/s/2ifgjqa8votdmnz/2556-06-07_at_6.39.40_PM.png" style="width: 500px" />
</p>

Here's how we worked, the larger the black circle is the higher amount
of commits.

<p style="text-align: center;">
  <img src="https://dl.dropbox.com/s/kxqo5n2qft174u5/2556-06-07_at_6.41.57_PM.png" />
</p>

And there came a presentation. There were 7 judges from different
IT company and startups, both Thais and foreigners. The judges were
separated into 3 groups. Each team had to present to each group of judges,
4 minutes for each presentation. Each group of judges would pick
one team to compete in a final round. So there would be 3 teams presenting
to all audiences in the final.

To be honest we didn't prepare any presentation. And Twitmap herself
wasn't designed to grow any business. So we did quite a weird
and awkward presentation. Basically what every judge asked about
are quite the same. Here're what we were asked about:

* How do you make money from this
* How to grow a project
* Mobile support

Obviously we didn't make to the final round. And I'm sorry to tell
that I couldn't remember any much thing at the end. For me the hacking
ended just right when Twitmap reached the Internet.

### Final Thoughts

The event itself was well arranged, interesting and fun,
but surely has a way to go forward. IMHO it would be nice if
there were more technical sessions and presentation. Only couple of
projects were presented to the audiences, would be great if
we could know them all, but that takes time.
Perhaps it would be nice if the event would be expanded to Fri-Sun.
We would have more room for cool things.

There're also sponsored prices, for example, this time Google Developer
offered an awesome price and it wasn't related to the grand price.
So if you plan to win these sponsored ones. Building the apps
that focus on their services gives you a better shot.

And to remind myself, for the limited working time like this,
planning is very important. Sky is not a limit but your stamina is.
I constantly coded for 10 hours and went exhausted (beers could help here ;) for real).
If you plan for a big thing you may not be able to make it. Focus on the main
feature, the rest are bonus.

Well, to sum up, a nice event, great facilities and support thanks to BU staff,
awesome people all around. Thanks to everybody making this happen.
I would definitely join #AngelHackBKK at the end of this year
if I had a chance :)
