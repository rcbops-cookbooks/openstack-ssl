name              "openstack-ssl"
maintainer        "Rackspace US, Inc."
license           "Apache 2.0"
description       "Helper definitions to configure SSL encryption for OpenStack services"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

%w{ centos ubuntu }.each do |os|
  supports os
end

%w{ apache2 openssl osops-utils }.each do |dep|
  depends dep
end
