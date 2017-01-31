# make sure we have the defaults installed
include_recipe 'ghost-blog'

include_recipe 'test::blog_example'
include_recipe 'test::nginx_example'
include_recipe 'ghost-blog::_services'
