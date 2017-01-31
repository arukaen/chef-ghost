# Install Ghost to a custom path, under a custom URL and passing some port.
ghost_blog 'test' do
  install_dir '/var/www/html/ghost_1'
  blog_url 'http://myblog.com'
  port 2378
  node_bin_path '/usr/local/bin/node' # on some platforms (e.g. ubuntu 14.04 with binary install)...
  # ...this needs to be overriden from the default /usr/bin/node
end
