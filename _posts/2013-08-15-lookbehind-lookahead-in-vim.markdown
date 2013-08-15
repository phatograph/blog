---
layout: post
title: "Lookbehind / Lookahead in Vim"
tags:
- Vim
---

Vim is just powerful, sometimes you might want to replace your code from `something` to `everything` or `someone`.
This is, matching the whole (or partially) of a string and replace (partially) of the string with another word.

I've found this very nice [post](http://www.inputoutput.io/lookbehind-lookahead-regex-in-vim/) describing
lookbehind/ahead in Vim clearly. Allow me to copy some of his content here.

### `something` becomes `someone`

{% highlight ruby %}
:%s/\(some\)\@<=thing/one/g
{% endhighlight%}

Searches for all strings starting with `some`, then matching `thing`
changes `thing` into `one`.

### `something` is not changed, but `everything` changes to `everyone`

{% highlight ruby %}
:%s/\(some\)\@<!thing/one/g
{% endhighlight%}

Searches for all strings not starting with `some`, then matching `thing`
changes `thing` into `one`.

### `something` becomes `everything`

{% highlight ruby %}
:%s/some\(thing\)\@=/every/g
{% endhighlight%}

Searches for all strings ending with `thing`, then matching `some`
changes `some` into `every`.

### `something` is not changed, but `someone` becomes `everyone`.

{% highlight ruby %}
:%s/some\(thing\)\@!/every/g
{% endhighlight%}

Searches for all strings not ending with `thing`, then matching `some`
changes `some` into `every`.
