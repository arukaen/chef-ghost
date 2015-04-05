remote_file '/tmp/ghost.zip' do
    source "https://ghost.org/zip/ghost-#{node['ghost_blog']['version']}.zip"
    not_if { ::File.exist?('/tmp/ghost.zip') }
end

execute 'unzip' do
    cwd '/tmp'
    command "unzip ghost.zip -d #{node['ghost_blog']['install_dir']}"
    not_if { ::File.directory?("#{node['ghost_blog']['install_dir']}") }
end

execute 'npm install' do
    cwd "#{node['ghost_blog']['install_dir']}" 
    command 'npm install --production'
end

execute 'forever install' do
    cwd "#{node['ghost_blog']['install_dir']}"
    command 'npm install forever -g; NODE_ENV=production forever start index.js'
end
