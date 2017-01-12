require 'shellwords'

class Chef
  class Resource
    class GhostBlogNginxConfig < ChefCompat::Resource
      resource_name :ghost_nginx

      default_action :create

      property :blog_name, String, required: true
      property :blog_domain, String, required: true
      property :proxy_port, Integer, required: true

      default_action :create

      action :create do
        nginx_attrs = node['ghost-blog']['nginx'].to_h
        nginx_attrs['ssl_certificate'] ||= "#{nginx_attrs['dir']}/ssl/#{blog_name}.crt"
        nginx_attrs['ssl_certificate_key'] ||= "#{nginx_attrs['dir']}/ssl/#{blog_name}.key"
        nginx_attrs['self_signed_ssl_certificate_subj'] ||= "/C=US/ST=Washington/L=Seattle/O=John Doe/OU=John Doe Industries/CN=*.#{blog_domain}/CN=#{blog_domain}"

        # Bring in the latest stable nginx from apt (will not upgrade, though)
        apt_repository 'nginx' do
          uri          'ppa:nginx/stable'
          distribution node['lsb']['codename']
        end

        package 'nginx'

        # Utilities to enable and disable nginx sites
        %w{nxensite nxdissite}.each do |nxscript|
          template "#{nginx_attrs['script_dir']}/#{nxscript}" do
            source "#{nxscript}.erb"
            mode '0755'
            owner 'root'
            group 'root'
          end
        end

        # Self-signed certificate (if needed)
        execute "generate self-signed cert #{nginx_attrs['self_signed']}" do
          command "openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout #{nginx_attrs['ssl_certificate_key'].to_s.shellescape} -out #{nginx_attrs['ssl_certificate'].to_s.shellescape} -subj #{nginx_attrs['self_signed_ssl_certificate_subj'].to_s.shellescape}"
          # TODO regen or extend if expired
          only_if do
            # We don't overwrite keys and certificates. Not our jam, yo.
            if nginx_attrs['ssl'] &&
              !::File.exist?(nginx_attrs['ssl_certificate']) &&
              !::File.exist?(nginx_attrs['ssl_certificate_key'])
            end
          end
          notifies :restart, 'service[nginx]'
        end

        # Create the server definition
        template "/etc/nginx/sites-available/#{blog_name}.conf" do
          source 'ghost.conf.erb'
          blog_domain blog_domain
          blog_name blog_name
          proxy_port proxy_port
          variables nginx_attrs
          owner 'root'
          group 'root'
        end

        # Enable the site
        bash 'enable site config' do
          user 'root'
          cwd '/etc/nginx/sites-available/'
          code <<-EOH
             nxdissite default
             nxensite #{blog_name}.conf
          EOH
        end


      end

      action :delete do


      end

      @action_class.class_eval do
        def sanitized_name
          name.tr('.', '-')
        end
      end
    end
  end
end