# Add a custom config to nginx to reverse proxy 127.0.0.1:2388 for myblog.com
ghost_nginx 'test' do
  blog_name 'test'
  blog_domain 'myblog.com'
  proxy_port 2378
end
