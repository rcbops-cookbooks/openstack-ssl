class Chef::Recipe::SSL
  def self.get_cert_paths(server, service, nodeish=nil)
    nodeish = node unless nodeish
    paths = { 'pkey'=>nil, 'cert'=>nil, 'cacert'=>nil }
    
    paths.keys.each do |key|
      if nodeish.has_key?(server) and
         nodeish[server].has_key?('services') and
         nodeish[server]['services'].has_key?(service) and
         nodeish[server]['services'][service].has_key?(key)

        Chef::Log.debug("SSL#get_cert_paths: using node override for #{key}")
        paths[key] = nodeish[server]['services'][service][key]

      elsif nodeish['ssl'].has_key?("global_#{key}")
        Chef::Log.debug("SSL#get_cert_paths: using global attr for #{key}")
        paths[key] = nodeish['ssl']["global_#{key}"]
      else
        Chef::Log.debug("SSL#get_cert_paths: using default attr for #{key}")
        paths[key] = nodeish['ssl']["default_#{key}"]
      end
    end
    paths
  end
end
