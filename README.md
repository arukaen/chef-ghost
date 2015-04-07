ghostblog Cookbook
==================
A [Chef](http://getchef.com/) cookbook for building and managing a [Ghost blog](http://docs.ghost.org/).

Requirements
------------

## nodejs and Chef:

* nodejs
* Chef 11+

## Platforms

* Ubuntu 12.04, 14.04

## Cookbooks:

This cookbook depends on the following community cookbooks:

* [nodejs](https://supermarket.chef.io/cookbooks/nodejs) '~> 2.4.0'

As of version 1.0 this cookbook is only tested on Ubuntu 12.04 & 14.04. As development is continued on CentOS,Debian and future Ubuntu versions will be supported. This cookbook is heavily configured via the attributes

Attributes
==========

This cookbook's attributes are broken up into different categories.

General settings
----------------

* `node['ghost']['install_dir']` - Installation directory for Ghost. Default is `/var/www/html/ghost`
* `node['ghost']['version']` - Ghost blog version. Default is `latest`. Will also take old versions `0.5.9, 0.5.8, etc`

Nginx settings
----------------

* `node['ghost']['nginx']['dir']` - Nginx directory. Default is `/etc/nginx`
* `node['ghost']['nginx']['script_dir']` - bin directory for scripts. Default is `/usr/bin`
* `node['ghost']['nginx']['server_name']` - Nginx server name. Default is `ghostblog.com`

Ghost app settings
----------------

* `node['ghost']['app']['server_url']` - Ghost app server url. Default is `localhost`
* `node['ghost']['app']['port']` - Ghost app port. Default is `2368`
* `node['ghost']['app']['mail_transport_method']` - Ghost app mailing method. Default is `SMTP`.
* `node['ghost']['app']['mail_service']` - Name of Mail service to use with nodemailer. Default is `nil`. Supports `Gmail`,`SES`, & `mailgun`.
* `node['ghost']['app']['mail_user']` - Username for select mail service. Default is `nil`
* `node['ghost']['app']['mail_passwd']` - Password for selected mail user. Default is `nil`
* `node['ghost']['ses']['aws_secret_key']` - AWS Secret key. Default is `nil`
* `node['ghost']['ses']['aws_access_key']` - AWS Access key. Default is `nil`
* `node['ghost']['app']['db_type']` - Type of database to use with Ghost. Default is `sqlite3`. Supports `sqlite3`, and `mysql`.
* `node['ghost']['mysql']['host']` - MySQL host. Default is `127.0.0.1`
* `node['ghost']['mysql']['user']` - MySQL user. Default is `ghost_blog`
* `node['ghost']['mysql']['passwd']` - MySQL password. Default is `ChangePasswordQuick!`
* `node['ghost']['mysql']['database']` - MySQL database name. Default is `ghost_db`
* `node['ghost']['mysql']['charset']` - MySQL charset. Default is `utf8`

Recipes
=======

default
-------

The main recipe. This will call all the additional recipes to configure and setup Ghost.

Usage
=====

Using this cookbook is relatively straightforward. Add the default
recipe to the run list of a node, or create a role.