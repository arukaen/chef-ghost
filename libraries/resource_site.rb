# require 'helpers'

class Chef
  class Resource
    class GhostBlogSite < ChefCompat::Resource
      resource_name :ghost_blog

      # actions :create, :delete
      default_action :create
      
      property :install_dir, String, required: true
      property :blog_url, String, required: true
      property :port, Integer, required: true
      property :node_bin_path, String, required: true, default: '/usr/bin/node'
      property :listen_address, String, required: true, default: '127.0.0.1'
      property :email_transport, String, required: false
      property :email_service, String, required: false
      property :email_user, String, required: false
      property :email_passwd, String, required: false
      property :aws_access_key, String, required: false
      property :aws_secret_key, String, required: false
      property :db_type, String, required: true, default: 'sqlite3'
      property :mysql_host, String, required: false
      property :mysql_user, String, required: false
      property :mysql_passwd, String, required: false
      property :mysql_name, String, required: false
      property :mysql_charset, String, required: false

      
=begin
      property :cookbook, String, default: 'cron', desired_state: false
      property :command, String, required: true
      property :user, String, default: 'root'
      property :mailto, [String, nil]
      property :path, [String, nil]
      property :home, [String, nil]
      property :shell, [String, nil]
      property :comment, [String, nil]
      property :environment, Hash, default: {}
      property :mode, [String, Integer], default: '0644'
=end

      default_action :create

      action :create do
        # TODO upgrade to latest ghost when there is a new one!
        remote_file "#{Chef::Config[:file_cache_path]}/ghost.zip" do
          source "https://ghost.org/zip/ghost-#{node['ghost-blog']['version']}.zip"
          not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/ghost.zip") }
        end

        directory install_dir do
          recursive true
        end

        execute 'unzip' do
          user 'root'
          command "unzip #{Chef::Config[:file_cache_path]}/ghost.zip -d #{install_dir}"
          not_if { ::File.exists?("#{install_dir}/index.js") }
        end

        nodejs_npm 'packages.json' do
          user 'root'
          json true
          path install_dir
          options ['--production']
        # TODO nodejs_npm seems like it's not really test-and-set. Fix that so we can
        # auto-restart ghost when the installation changes.
        #    notifies :restart, 'service[ghost]'
        end

        template "/etc/init.d/ghost_#{sanitized_name}" do
          source 'ghost.init.erb'
          owner 'root'
          group 'root'
          mode '0755'
          variables(
            :name => sanitized_name,
            :install_dir => install_dir,
            :node_bin_path => node_bin_path
          )

          notifies :restart, "service[ghost_#{sanitized_name}]"
        end

        template "#{install_dir}/config.js" do
          source 'config.js.erb'
          owner 'root'
          group 'root'
          variables(
            :url => blog_url,
            :port => port,
            :listen_address => listen_address,
            :transport => email_transport,
            :service => email_service,
            :user => email_user,
            :passwd => email_passwd,
            :aws_access => aws_access_key,
            :aws_secret => aws_secret_key,
            :db_type => db_type,
            :db_host => mysql_host,
            :db_user => mysql_user,
            :db_passwd => mysql_passwd,
            :db_name => mysql_name,
            :charset => mysql_charset
          )
          notifies :restart, "service[ghost_#{sanitized_name}]"
        end

        service "ghost_#{sanitized_name}" do
           supports :status => true, :restart => true, :reload => true, :start => true, :stop => true
           action   :nothing
        end

      end

      action :delete do

        service "ghost_#{sanitized_name}" do
          action   :delete
        end

        template "#{node['ghost-blog']['install_dir']}/config.js" do
          action :delete
        end

        template "/etc/init.d/ghost_#{sanitized_name}" do
          action :delete
        end

        directory install_dir do
          recursive true
          action :delete
        end
      end

      @action_class.class_eval do
        def sanitized_name
          name.tr('.', '-')
        end
      end
    end
  end
end