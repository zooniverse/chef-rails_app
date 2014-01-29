template_vars = {
  env: node['rails_app']['environment']
}

node['rails_app']['configuration']['vars'].each do |k, v|
  template_vars[k.to_sym] = v
end

directory "/rails/apps/#{node['rails_app']['name']}/shared/config" do
  action :create
  owner node['rails_app']['user']
  group node['rails_app']['group']
  mode "0775"
end

node['rails_app']['configuration']['files'].each do |f|
  template "/rails/apps/#{node['rails_app']['name']}/shared/config/#{f}.yml" do
    source "#{f}.yml.erb"
    variables template_vars
    owner node['rails_app']['user']
    mode "0755"
    action :create
  end

  unless ::File.exist?("/rails/apps/#{node['rails_app']['name']}/current/config/#{f}.yml")
    execute "symlink_config" do
      command "ln -s /rails/apps/#{node['rails_app']['name']}/shared/config/#{f}.yml /rails/apps/#{node['rails_app']['name']}/current/config/#{f}.yml"
    end
  end
end
