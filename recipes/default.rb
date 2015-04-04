#
# Cookbook Name:: ghostblog
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

 include_recipe 'nodejs'
 include_recipe 'zip'
 include_recipe 'ghostblog::_nginx'
 include_recipe 'ghostblog::_services'
 include_recipe 'ghostblog::_ghost'
