include_recipe 'mysql::server'

if node['mysql']['stop_service']

  service "mysql" do
    action :stop
  end
end


