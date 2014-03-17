include_recipe "ruby_build"
include_recipe "rbenv::system_install"

rbenv_ruby node['rails_app']['ruby_version'] do
  action :install
end

rbenv_global node['rails_app']['ruby_version'] do
  action :create
end

rbenv_gem "rubygems-update" do
  action :install
  rbenv_version node['rails_app']['ruby_version']
end

rbenv_script "update rubygems" do
  code "gem update --system"
end

group node['rails_app']['group'] do
  action :create
  members "vagrant"
end

user node['rails_app']['user'] do
  gid node['rails_app']['group']
end

directory "/rails" do
  action :create
  owner node['rails_app']['user']
  group node['rails_app']['group']
  mode "0775"
end

directory "/rails/apps" do
  action :create
  owner node['rails_app']['user']
  group node['rails_app']['group']
  mode "0775"
end

directory "/rails/apps/#{node['rails_app']['name']}" do
  action :create
  owner node['rails_app']['user']
  group node['rails_app']['group']
  mode "0775"
end
