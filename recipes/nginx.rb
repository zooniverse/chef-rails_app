include_recipe "nginx-zoo"
include_recipe "unicorn"

template "/usr/local/nginx/conf/sites-available/#{node['rails_app']['name']}.conf" do
  source "default.conf.erb"
  owner node['nginx']['user']
  group node['nginx']['group']
  mode "0644"
  variables({app_name: node['rails_app']['name']})
  action :create
end

unless ::File.exist?("/usr/local/nginx/conf/sites-enabled/#{node['rails_app']['name']}.conf")
  src =  "/usr/local/nginx/conf/sites-available/#{node['rails_app']['name']}.conf"
  dest = "/usr/local/nginx/conf/sites-enabled/#{node['rails_app']['name']}.conf"
  execute "symlink to sites-enabled" do
    command "ln -s #{src} #{dest}"

    notifies :restart, "service[nginx]"
    notifies :start, "service[#{node['unicorn']['site']['name']}]"
  end
end
