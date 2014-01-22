include_recipe "ruby_build"
include_recipe "rbenv::system_install"

rbenv_ruby node['rails_app']['ruby_version'] do
  action :install
end

rbenv_global node['rails_app']['ruby_version'] do
  action :create
end

gem_package "bundler" do
  action :install
end

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