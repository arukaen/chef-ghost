# Add a custom config to nginx to reverse proxy 127.0.0.1:2388 for myblog.com
ghost_nginx 'test2' do
  blog_name 'test2'
  blog_domain 'myblog.com'
  proxy_port 2388
end