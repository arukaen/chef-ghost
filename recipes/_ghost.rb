version = node['ghost_blog']['version']

remote_file '/tmp/ghost.zip' do
    source "https://ghost.org/zip/ghost-#{version}.zip"
end

execute 'unzip' do
    cwd '/tmp'
    command "unzip ghost.zip -d #{node['ghost_blog']['install_dir']}"
    not_if { ::File.directory?('/var/www/ghostblog') }
end

execute 'npm install' do
    cwd '/var/www/ghostblog'
    command 'npm install --production'
end
