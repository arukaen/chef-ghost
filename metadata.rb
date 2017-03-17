name             'ghost-blog'
maintainer       'Cris Gallardo, Yorgos Saslis'
maintainer_email 'c@cristhekid.com, yorgo@protonmail.com'
license          'Apache 2.0'
description      'Installs & configures Ghost: open source blogging platform'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.1.0'
issues_url 'https://github.com/arukaen/chef-ghost/issues'
source_url 'https://github.com/arukaen/chef-ghost'

#have to be more specific due to version constraints
supports 'ubuntu', '>= 14.04'
supports 'rhel', '>= 7'
supports 'centos' '>= 7'

depends 'nodejs', '>= 2.4.0'
