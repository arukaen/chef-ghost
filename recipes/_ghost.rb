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
    user 'root'
    json true
    path "#{node['ghost']['install_dir']}"
    options ['--production']
end

template '/etc/init.d/ghost' do
    source 'ghost.init.erb'
    owner 'root'
    group 'root'
    mode '0755'
end

template "#{node['ghost']['install_dir']}/config.js" do
    source 'config.js.erb'
    owner 'root'
    group 'root'
    notifies :start, 'service[ghost]', :immediately
end

#nodejs_npm 'forever'
#
#execute 'start ghost with forever' do
#    cwd "#{node['ghost']['install_dir']}"
#    command 'NODE_ENV=production forever start index.js'
#end
