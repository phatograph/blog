---
layout: post
title: "Handmade Timestamp Service in OSX"
tags:
- osx
---

When I need to test a form while developing, I was really bored and too lazy to think of some text to fill in any text input. Things like `dasdsa` or `sajklhdas` are too messy, and even though I have [LittleIpsum](http://littleipsum.com/) installed it still takes too many clicks and mouse dragging. There must be a better way. I thought about using a timestamp.

So I found this [post](http://superuser.com/questions/227213/what-is-the-easiest-way-to-get-a-yyyy-mm-dd-hhmmss-timestamp-hotkey-on-the-mac). Easy handmade service could do the job. Here's how to set it up.

- Launch **Automator.app**, add new **Service**.
- Search for **Run Shell Script** and fill in `date "+%Y-%m-%d %T"`, I'm using `/bin/zsh` by the way.
- At the upper **Service receives** section, select **no input** and **any application**, also check **Output replaces selected text**.
- Save the service, I named it **Insert Timestamp**.

![img](http://dl.dropboxusercontent.com/s/hg6p2dywe1ck1s5/2556-04-26_at_9.14.04_PM.png)

- Now go to **System Preferences** and **Keyboard**, in the **Keyboard Shortcuts** tab you will find your newly created service within the **Text** dropdown. Check to activate it and assign a keyboard shortcut. I use `cmd + ctrl + shift + D` for my setup.

![img](http://dl.dropboxusercontent.com/s/6khzilblhj473id/2556-04-26_at_9.19.55_PM.png)

And that's it! Let's enjoy this little handy trick ;)
