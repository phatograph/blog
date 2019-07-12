---
layout: post
title: "Installing PostgresSQL on Ubuntu 12.04"
tags:
- ubuntu
---

I had to find a new home for [Teeview](http://teeview.phatograph.com)
since its free plan was running full. So I would like it to use
and external Postgres hosting on a VPS. So here're simple processes
to setup PostgreSQL on Ubuntu 12.04. Enjoy!

First, perform a quick update of the apt-get repository.

<pre><code class="language-bash">
$ sudo apt-get update
</code></pre>

Once apt-get has updated go ahead and download Postgres and its
helpful accompanying dependencies.

<pre><code class="language-bash">
$ sudo apt-get install postgresql postgresql-contrib
</code></pre>

Postgres is installed, now time to set a new password for `postgres` user.

<pre><code class="language-bash">
$ sudo -u postgres psql

> \password postgres  # and type in a new password
> \q  # to quit postgres console
</code></pre>

Move on to configure postgres.

<pre><code class="language-bash">
$ cd /etc/postgresql/9.1/main
$ cp pg_hba.conf pg_hba.conf.bak.original  # backup default configuration
$ cp postgresql.conf postgresql.conf.bak.original
</code></pre>

Enable remote access from any IP address (with password required).
Add this line to `pg_hba.conf`:

<pre><code class="language-bash">
host  all   all   0.0.0.0/0   md5
</code></pre>

Allow TCP/IP socket. Modify this line in `postgresql.conf`

<pre><code class="language-bash">
listen_addresses='*'
</code></pre>

And restart Postgres after finish configuration.

<pre><code class="language-bash">
/etc/init.d/postgresql restart
</code></pre>

Also make sure you enable a firewall for Postgres.

<pre><code class="language-bash">
$ sudo ufw allow 5432
$ sudo ufw status

To                         Action      From
--                         ------      ----
###
5432                       ALLOW       Anywhere
5432                       ALLOW       Anywhere (v6)
###
</code></pre>

And done! Now you have your Postgres running and can be accessed from any remote.
Thanks to many posts help me setting all this up.

Refs:
[1](https://www.digitalocean.com/community/articles/how-to-install-and-use-postgresql-on-ubuntu-12-04)
, [2](http://railskey.wordpress.com/2012/05/19/postgresql-installation-in-ubuntu-12-04/)
, [3](http://stackoverflow.com/questions/15418056/setting-up-postgres-cant-connect-remotely-to-postgres-server-debian)
, [4](http://stackoverflow.com/questions/3278379/how-to-configure-postgresql-to-accept-all-incoming-connections)
, [5](http://stackoverflow.com/questions/12720967/is-possible-to-check-or-change-postgresql-user-password)
, [6](http://www.cyberciti.biz/tips/postgres-allow-remote-access-tcp-connection.html)
