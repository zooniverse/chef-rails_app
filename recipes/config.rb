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
  template_path = "/rails/apps/#{node['rails_app']['name']}/shared/config/#{f}.yml"
  unless ::File.exist?(template_path)
    template template_path do
      source "#{f}.yml.erb"
      variables template_vars
      owner node['rails_app']['user']
      mode "0755"
      action :create
    end
  end

  config_file_path = "/rails/apps/#{node['rails_app']['name']}/current/config/#{f}.yml"
  execute "symlink_config" do
    command "if [ ! -e \"#{config_file_path}\" ] ; then ln -s #{template_path} #{config_file_path} ; fi"
  end
end
