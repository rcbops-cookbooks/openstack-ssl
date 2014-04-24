define :ssl_endpoint, :cookbook => 'openstack-ssl', :template => 'vhost.conf.erb', :enable => true do

  service_name = params[:name]
  vhost_file = "#{node['apache']['dir']}/sites-available/#{service_name}.conf"

  include_recipe 'apache2::default'
  include_recipe 'apache2::mod_ssl'
  include_recipe 'apache2::mod_rewrite'
  include_recipe 'apache2::mod_headers'
  include_recipe 'apache2::mod_proxy'
  include_recipe 'apache2::mod_proxy_http'

  template vhost_file do
    source   params[:template]
    cookbook params[:cookbook] if params[:cookbook]
    group    node['apache']['root_group']
    owner    'root'
    mode     '0644'
    variables(
      :service_name => service_name,
      :params       => params
    )
    if ::File.exists?(vhost_file)
      notifies :reload, 'service[apache2]'
    end
  end

  site_enabled = params[:enable]
  apache_site "#{params[:name]}.conf" do
    enable site_enabled
  end
end
