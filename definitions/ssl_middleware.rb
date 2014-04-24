define :ssl_middleware, :cookbook => 'openstack-ssl', :template => 'ssl.py.erb', :services => [] do

  # variables for different parts of the file path that eventually
  # form /usr/lib/python2.7/glance/api/middleware/ssl.py
  library_dir = get_lib_path(node['platform_family'])
  project_dir = ::File.join(library_dir, params[:name])
  midware_dir = ::File.join(project_dir, 'api/middleware')
  initpy_file = ::File.join(midware_dir, '__init__.py')
  target_file = ::File.join(midware_dir, 'ssl.py')

  # make sure we have a middleware directory
  %w[ project_dir midware_dir ].each do |path|
    directory path
  end

  # make sure we have __init__.py for middleware dir
  file initpy_file do
    owner  'root'
    group  'root'
    mode   '0644'
    action :create_if_missing
  end
                              
  # create ssl.py
  template target_file do
    source   params[:template]
    cookbook params[:cookbook] if params[:cookbook]
    owner    'root'
    group    'root'
    mode     '0644'
    variables(
      :project  => params[:name],
      :wsgi_lib => params[:wsgi_lib]
    )
    params[:services].each do |svc|
      notifies :restart, "service[#{svc}]"
    end
  end

  # create a .pyc 
  execute 'pycompile ssl.py' do
    command "pycompile #{target_file}"
    not_if "test -f #{target_file}c"
  end
end
