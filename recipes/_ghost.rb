remote_file '/tmp/ghost.zip' do
    source "https://ghost.org/zip/ghost-#{node['ghost']['version']}.zip"
    not_if { ::File.exist?('/tmp/ghost.zip') }
end

execute 'unzip' do
    cwd '/tmp'
    user 'root'
    command "unzip ghost.zip -d #{node['ghost']['install_dir']}"
    not_if { ::File.directory?("#{node['ghost']['install_dir']}") }
end

nodejs_npm 'packages.json' do
    json true
    path "#{node['ghost']['install_dir']}"
    user 'root'
    group 'root'
    options ['--production']
end

nodejs_npm 'forever'

execute 'start ghost with forever' do
    cwd "#{node['ghost']['install_dir']}"
    command 'NODE_ENV=production forever start index.js'
end
