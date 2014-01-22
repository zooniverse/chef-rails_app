directory "/rails" do
  action :create
  owner node['rails_app']['user']
  group node['rails_app']['user']
  mode 0775
end

directory "/rails/apps" do
  action :create
  owner node['rails_app']['user']
  group node['rails_app']['user']
  mode 0775
end