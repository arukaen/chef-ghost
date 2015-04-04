 apt_repository 'nginx' do
   uri          'ppa:nginx/stable'
   distribution 'precise'
 end

 package 'nginx'

 %w{nxensite nxdissite}.each do |nxscript|
     template "#{node['ghost_blog']['nginx']['script_dir']}/#{nxscript}" do
     source "#{nxscript}.erb"
     mode '0755'
     owner 'root'
     group 'root'
   end
 end

 directory '/var/www/' do
    recursive true
 end
