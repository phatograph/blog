---
layout: post
title: "Travis to the rescue"
tags:
- Travis
---

One thing I don't like about Octopress it requires too much steps to write a single blog post. You have to:

- Create a new post `rake new_post['Malesuada Ornare Mollis']`
- Write a content
- Generate static files `rake generate`
- Deploy the generated site `rake deploy`

This is insane. 4 steps and terminal is required ? I just want to edit directly from the browser, and sometimes from Sublime.

So [Travis CI](https://travis-ci.org/) crossed my mind. What if I just push changes to `master` and let CI generate and deploy for me. Would be nice. And there is also [prose.io](http://prose.io/) to make writing Markdown fancy.

I tried with my own and I couldn't customize Travis for my needs. So I came across this [post](http://darvin.github.io/blog/2013/01/13/Prose_Octopress_TravisIO/) from Sergey Klimov. This saved my day. I would like to break things down here a bit. Several things are needed for this ritual to work.

### Generating encrypted SSH key for Travis

In order to make this happen, Travis has to hold our GitHub deploy SSH key. The key is needed to be encrypted too. Travis already provides the `travis encrypt` from its gem. Luke Patterson came up with this [gist](https://gist.github.com/lukewpatterson/4242707) to make this easier, allow me to paste a part of it here:

{% highlight bash %}
$ base64 --wrap=0 ~/.ssh/id_rsa > ~/.ssh/id_rsa_base64
$ ENCRYPTION_FILTER="echo \$(echo \"-\")\$(travis encrypt veewee-community/veewee-push \"\$FILE='\`cat $FILE\`'\" | grep secure:)"
$ split --bytes=100 --numeric-suffixes --suffix-length=2 --filter="$ENCRYPTION_FILTER" ~/.ssh/id_rsa_base64 id_rsa_
{% endhighlight %}

Basically (I think) it would encode our `id_rsa` in base64, split each line of them and run `travis encrypt .. --add`, resulting in the encrypted strings are appended to the `.travis.yml`

Unfortunately this doesn't work in my OSX somehow (due to the `split` command). So I just `base64` my `id_rsa`, get that `id_rsa_base64`, open it, and do something like this.

{% highlight bash %}
$ travis encrypt id_rsa_00=LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpQcm9jLVR5cGU6IDQsRU5DUllQVEVE --add
$ travis encrypt id_rsa_01=CkRFSy1JbmZvOiBBRVMtMTI4LUNCQyxFNDQ2OTNEQkMzNjcxOERFNTc5QzQ4MTQyNUExQjg4 --add
$ travis encrypt id_rsa_02=OQoKMXhlbEljK2xlVGVNdlVrSUxNRE9LdCtsL1hQZy9VYy9zYXRrNGJUeWVPcnhLMnVmUysz --add
$ travis encrypt
...
{% endhighlight %}

Hahaha I know this is horrible. Would have come up with more neat solution someday. For now I just paste those line in my terminal, then I have my encrypted key appended in `.travis.yml`.

One thing, the SSH must not have the passphrase, Travis won't be able to enter it via the prompt.

Another thing to note is this encrypted key is for per-repo. You may to run those `travis encrypt` separately for each repository.

### The `.travis.yml` itself

Sergey has provided his cool `.travis.yml` for this ritual in his post. I modified it a bit, here is what the file looks like:

{% highlight ruby %}
---
language: ruby
rvm:
- 1.9.3
before_script:
- git remote set-url origin $REPO.git
- git config --global user.email "phatograph@gmail.com"
- git config --global user.name "Phat Wangrungarun (via TravisCI)"
- echo -n $id_rsa_{00..32} >> ~/.ssh/id_rsa_base64
- base64 --decode --ignore-garbage ~/.ssh/id_rsa_base64 > ~/.ssh/id_rsa
- chmod 600 ~/.ssh/id_rsa
- echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
- rake setup_github_pages[$REPO]
script:
- bundle exec rake generate
- bundle exec rake deploy
env:
  global:
  - REPO="git@github.com:phatograph/blog"
  - secure: ! 'Sge5rCthtw0QGTfqVGvkVMVP/4RQwwnjM0YYnxeTmImi4cwWQkXDXSuctkKz

      FoGzyvzB75Zbu86Yf9yD5M+2QOdYru4DZdq/d17AEnwFnB+ETjxRcnSbzJaK
{% endhighlight %}

The rest of the file is the encrypted key from `travis encrypt`, just leave it alone.

What this does is it would decrypt the keys, assign them to `$id_rsa_00`, `$id_rsa_01`, `$id_rsa_02` and so on, gather them together in `~/.ssh/id_rsa_base64`. Then run a `base64 --decode --ignore-garbage` to make `~/.ssh/id_rsa`. Now we have our ssh key for Travis to push to GitHub, really nice. The left is just set the path to push, generate, and deploy.

### Job is done

So far it seems too complex to write a blog. But for me it's fun to figure these things out (and it works). I have my blog, it's under [version control](https://github.com/phatograph/blog/tree/master), it's [open source](https://github.com/phatograph/blog/), even its own [CI](https://travis-ci.org/phatograph/blog). Octopress and friends are cool for me for now. ;)
