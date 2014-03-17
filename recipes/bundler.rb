rbenv_gem "bundler" do
  action :install
  rbenv_version node['rails_app']['ruby_version']
end

rbenv_script "bundle install" do
  cwd "/rails/apps/#{node['rails_app']['name']}/current"
  code "bundle install"
end
