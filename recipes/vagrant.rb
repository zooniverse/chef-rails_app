unless ::File.exists?("/rails/apps/#{node['rails_app']['name']}/current")
  execute "symlink vagrant shared folder" do
    cwd "/rails/apps/#{node['rails_app']['name']}"
    command "ln -s /vagrant ./current"
  end
end

directory "/rails/apps/#{node['rails_app']['name']}/shared" do
  action :create
  owner node['rails_app']['user']
  group node['rails_app']['group']
  mode "0775"
end

if node['rails_app']['config_tarball']
  remote_file ::File.join(Chef::Config[:file_cache_path], "rails_config.tar.gz") do
    action :create
    owner 'root'
    mode '0644'
    source node['rails_app']['config_tarball']
  end

  unless ::File.exist?("/rails/apps/#{node['rails_app']['name']}/shared/config") 
    execute 'install and symlink configuration' do
      cwd Chef::Config[:file_cache_path]
      command """
        tar -C /rails/apps/#{node['rails_app']['name']}/shared -zxf rails_config.tar.gz && \
        cp -rs /rails/apps/#{node['rails_app']['name']}/shared/config /rails/apps/#{node['rails_app']['name']}/current/config/
      """
    end
  end
else
  include_recipe "rails_app::config"
end

unless node['rails_app']['packages'].empty?
  include_recipe 'rails_app::packages'
end

if node['rails_app']['use_bundler']
  include_recipe 'rails_app::bundler'
end
