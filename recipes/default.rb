#
# Cookbook Name:: ghost
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

 include_recipe 'nodejs'
 package 'unzip'

 # Example: this is how you'd install 2 Ghost blogs on the same host

 # ghost_blog 'test' do
 #   install_dir '/var/www/html/ghost_1'
 #   blog_url 'http://myblog.com'
 #   port 2378
 #   node_bin_path '/usr/local/bin/node'
 # end

 # ghost_blog 'test2' do
 #   install_dir '/var/www/html/ghost_2'
 #   blog_url 'http://myblog.net'
 #   port 2388
 #   node_bin_path '/usr/local/bin/node'
 # end

 # ghost_nginx 'test2' do
 #   blog_name 'test2'
 #   blog_domain 'myblog.com'
 #   proxy_port 2388
 # end