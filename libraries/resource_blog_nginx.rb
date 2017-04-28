require 'shellwords'

class Chef
  class Resource
    # This class implements the new custom resource used for managing the nginx configuration as a reverse proxy.
    class GhostBlogNginxConfig < ChefCompat::Resource
      resource_name :ghost_nginx

      default_action :create

      property :blog_name, String, required: true
      property :blog_domain, String, required: true
      property :proxy_port, Integer, required: true
      property :ssl, [true, false]
      property :redir_behind_lb, [true, false], required: true, default: false



      action :create do
        nginx_attrs = node['ghost-blog']['nginx'].to_h

        nginx_attrs['ssl_certificate'] ||= "#{nginx_attrs['dir']}/ssl/#{blog_name}.crt"
        nginx_attrs['ssl_certificate_key'] ||= "#{nginx_attrs['dir']}/ssl/#{blog_name}.key"
        nginx_attrs['self_signed_ssl_certificate_subj'] ||=
          '/C=US/ST=Washington/L=Seattle/O=John Doe/'\
          "OU=John Doe Industries/CN=*.#{blog_domain}/CN=#{blog_domain}"
        nginx_attrs['blog_name'] ||= blog_name
        nginx_attrs['blog_domain'] ||= blog_domain
        nginx_attrs['port'] ||= proxy_port
        # a little different because the above aren't defined by default
        # override if we're setting in the resource block
        nginx_attrs['ssl'] = ssl if defined? ssl
        nginx_attrs['redir_behind_lb'] = redir_behind_lb

        # Bring in the latest stable nginx from apt (will not upgrade, though)
        apt_repository 'nginx' do
          uri          'ppa:nginx/stable'
          distribution node['lsb']['codename']
        end

        package 'nginx'

        case node[:platform_family]
        when 'debian'
          # Utilities to enable and disable nginx sites
          %w(nxensite nxdissite).each do |nxscript|
            template "#{nginx_attrs['script_dir']}/#{nxscript}" do
              source "#{nxscript}.erb"
              cookbook 'ghost-blog'
              mode '0755'
              owner 'root'
              group 'root'
            end
          end
        end

        if nginx_attrs['ssl'] then
          # Self-signed certificate (if needed)
          execute "generate self-signed cert #{nginx_attrs['self_signed']}" do
            command "openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
              -keyout #{nginx_attrs['ssl_certificate_key'].to_s.shellescape} \
              -out #{nginx_attrs['ssl_certificate'].to_s.shellescape}
              --subj #{nginx_attrs['self_signed_ssl_certificate_subj'].to_s.shellescape}"
            # TODO: regen or extend if expired
            only_if do
              # We don't overwrite keys and certificates. Not our jam, yo.
              if nginx_attrs['ssl'] &&
                 !::File.exist?(nginx_attrs['ssl_certificate']) &&
                 !::File.exist?(nginx_attrs['ssl_certificate_key'])
              end
            end
            notifies :restart, 'service[nginx]'
          end
        end


        # Create the server definition
        case node[:platform_family]
        when "rhel"
          template "/etc/nginx/conf.d/#{blog_name}.conf" do
            source 'ghost.conf.erb'
            cookbook 'ghost-blog'
            variables nginx_attrs
            owner 'root'
            group 'root'
          end
        when "debian"
          template "/etc/nginx/sites-available/#{blog_name}.conf" do
            source 'ghost.conf.erb'
            cookbook 'ghost-blog'
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
      end

      @action_class.class_eval do
        def sanitized_name
          name.tr('.', '-')
        end
      end
    end
  end
end
