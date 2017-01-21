name             'ghost-blog'
maintainer       'Cris Gallardo, Yorgos Saslis'
maintainer_email 'c@cristhekid.com, yorgo@protonmail.com'
license          'Apache 2.0'
description      'Installs & configures Ghost: open source blogging platform'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.0.0'
issues_url 'https://github.com/arukaen/chef-ghost/issues'
source_url 'https://github.com/arukaen/chef-ghost'

%w( ubuntu ).each do |os|
  supports os
end

depends 'nodejs', '~> 2.4.0'
