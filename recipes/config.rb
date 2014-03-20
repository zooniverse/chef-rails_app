prod_env = node.chef_environment == "production"
template_vars = {}

node['rails_app']['configuration']['vars'].each do |k, v|
  template_vars[k.to_sym] = v
end

if prod_env
  directory "/rails/apps/#{node['rails_app']['name']}/shared/config" do
    action :create
    owner node['rails_app']['user']
    group node['rails_app']['group']
    mode "0775"
  end
end

node['rails_app']['configuration']['files'].each do |f|
  rails_config_root = prod_env ? "shared" : "current"
  template_path = "/rails/apps/#{node['rails_app']['name']}/#{rails_config_root}/config/#{f}.yml"
  template_vars[:envs] = [ node['rails_app']['environment'] ] | %w(test development staging production)
  unless ::File.exist?(template_path)
    template template_path do
      source "#{f}.yml.erb"
      variables template_vars
      owner node['rails_app']['user']
      group node['rails_app']['group']
      mode "0775"
      action :create
    end
  end

  if prod_env
    config_file_path = "/rails/apps/#{node['rails_app']['name']}/current/config/#{f}.yml"
    execute "symlink_production_config_files" do
      command "if [ ! -e \"#{config_file_path}\" ] ; then ln -s #{template_path} #{config_file_path} ; fi"
    end
  end
end
