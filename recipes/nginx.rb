include_recipe 'rails_app::default'

app[:user] ||= node[:user]
app[:group] ||= app[:user]
app_dir = "/rails/apps/#{ app[:name] }"

directory app_dir do
  owner app[:user]
  group app[:group]
  mode 0755
  action :create
  recursive true
end

directory "#{ app_dir }/shared" do
  owner app[:user]
  group app[:group]
  mode 0755
  action :create
  recursive true
end

directory "#{ app_dir }/shared/config/" do
  owner app[:user]
  group app[:group]
  mode 0755
  action :create
end

directory "#{ app_dir }/shared/logs" do
  action :create
  mode 0755
  owner app[:user]
  group app[:group]
end

directory "#{ app_dir }/releases" do
  owner app[:user]
  group app[:group]
  mode 0755
  action :create
end

directory "#{ app_dir }/current" do
  owner app[:user]
  group app[:group]
  mode 0755
  action :create
end

if app[:gems]
  app[:gems].each do |g|
    if g.is_a? Array
      gem_package g.first do
        version g.last
      end
    else
      gem_package g
    end
  end
end

if app[:packages]
  app[:packages].each do |package_name|
    package package_name
  end
end

if app[:symlinks]
  app[:symlinks].each do |target, source|
    link target do
      to source
    end
  end
end
