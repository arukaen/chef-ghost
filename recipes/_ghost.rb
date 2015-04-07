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
    variables(
        :url => node['ghost']['app']['server_url'],
        :port => node['ghost']['app']['port'],
        :transport => node['ghost']['app']['mail_transport_method'],
        :service => node['ghost']['app']['mail_service'],
        :user => node['ghost']['app']['mail_user'],
        :passwd => node['ghost']['app']['mail_passwd'],
        :aws_access => node['ghost']['ses']['aws_access_key'],
        :aws_secret => node['ghost']['ses']['aws_secret_key'],
        :db_type => node['ghost']['app']['db_type'],
        :db_host => node['ghost']['mysql']['host'],
        :db_user => node['ghost']['mysql']['user'],
        :db_passwd => node['ghost']['mysql']['passwd'],
        :db_name => node['ghost']['mysql']['database'],
        :charset => node['ghost']['mysql']['charset']
    )
    notifies :start, 'service[ghost]', :immediately
end
