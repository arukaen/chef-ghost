name             'ghostblog'
maintainer       'Cris Gallardo'
maintainer_email 'c@cristhekid.com'
license          'All rights reserved'
description      'Installs & configures Ghost: open source blogging platform'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

supports 'ubuntu', '>= 12.04'
supports 'ubuntu', '>= 14.04'

depends 'nodejs', '~> 2.4.0'
