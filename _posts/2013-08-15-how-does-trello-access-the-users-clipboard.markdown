---
layout: post
title: "How does Trello access the user's clipboard ?"
tags:
- javascript
---

This is definitely a wise UX way, using user behavior.
It's an answer to a [question](http://stackoverflow.com/questions/17527870/how-does-trello-access-the-users-clipboard/17528590)
on StackOverflow from Daniel LeCheminant.

> We don't actually "access the user's clipboard", instead we help the user out a bit by selecting something useful when they press `Ctrl+C`.

> Sounds like you've figured it out; we take advantage of the fact that when you want to hit `Ctrl+C`,
you have to hit the `Ctrl` key first. When the `Ctrl` key is pressed,
we pop in a textarea that contains the text we want to end up on the clipboard,
and select all the text in it, so the selection is all set when the `C` key is hit.
(Then we hide the textarea when the `Ctrl` key comes up)

> Specifically, Trello does this:

{% highlight coffeescript %}
TrelloClipboard = new class
  constructor: ->
    @value = ""

    $(document).keydown (e) =>
      # Only do this if there's something to be put on the clipboard, and it
      # looks like they're starting a copy shortcut
      if !@value || !(e.ctrlKey || e.metaKey)
        return

      if $(e.target).is("input:visible,textarea:visible")
        return

      # Abort if it looks like they've selected some text (maybe they're trying
      # to copy out a bit of the description or something)
      if window.getSelection?()?.toString()
        return

      if document.selection?.createRange().text
        return

      _.defer =>
        $clipboardContainer = $("#clipboard-container")
        $clipboardContainer.empty().show()
        $("<textarea id='clipboard'></textarea>")
        .val(@value)
        .appendTo($clipboardContainer)
        .focus()
        .select()

    $(document).keyup (e) ->
      if $(e.target).is("#clipboard")
        $("#clipboard-container").empty().hide()

  set: (@value) ->
{% endhighlight %}

{% highlight html %}
<div id="clipboard-container"><textarea id="clipboard"></textarea></div>
{% endhighlight %}

{% highlight css %}
/* CSS for the clipboard stuff */
#clipboard-container {
  position: fixed;
  left: 0px;
  top: 0px;
  width: 0px;
  height: 0px;
  z-index: 100;
  display: none;
  opacity: 0;
}
#clipboard {
  width: 1px;
  height: 1px;
  padding: 0px;
}
{% endhighlight %}

> ... and the CSS makes it so you can't actually see the textarea when it pops in ... but it's "visible" enough to copy from.

> When you hover over a card, it calls

{% highlight js %}
TrelloClipboard.set(cardUrl)
{% endhighlight %}

> ... so then the clipboard helper knows what to select when the `Ctrl` key is pressed.
