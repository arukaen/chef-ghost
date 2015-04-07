#
# Cookbook Name:: ghostblog
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

 include_recipe 'nodejs'
 package 'unzip'
 include_recipe 'ghostblog::_nginx'
 include_recipe 'ghostblog::_services'
 
 if node['ghost']['app']['db_type'] == 'mysql'
    include_recipe 'ghostblog::_mysql'
    include_recipe 'ghostblog::_ghost'
 else
    include_recipe 'ghostblog::_ghost'
 end
