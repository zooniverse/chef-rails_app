gem_package "bundler" do
  action :install
end

execute "bundle install" do 
  cwd "/rails/apps/#{node['rails_app']['name']}/current"
  command "bundle install && rbenv rehash"
end