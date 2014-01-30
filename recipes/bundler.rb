rbenv_gem "bundler" do
  action :install
  rbenv_version node['rails_app']['ruby_version']
end

execute "bundle install" do 
  cwd "/rails/apps/#{node['rails_app']['name']}/current"
  command "bundle install"
end