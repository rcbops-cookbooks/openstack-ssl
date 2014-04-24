module RCB
  module Python

    # Get the install location of OpenStack libraries.
    #
    # This is usually a standard Python interpreter path (from sys.path),
    # but it's different between platforms and there's no simple way
    # to guess which one it is dynamically; it's easier and more accurate
    # to just query the damn openstack package.
    #
    def get_lib_path(platform)
      case platform
      when 'rhel'
        pkg_cmd = 'rpm -ql'
      when 'debian'
        pkg_cmd = 'dpkg -L'
      else
        Chef::Log.fatal("Unsupported platform: #{platform}")
      end

      # output looks like:
      #  /usr/lib/python2.6/site-packages/novaclient (rhel) or
      #  /usr/lib/python2.7/dist-packages/novaclient (ubuntu)
      #
      cmd = "#{pkg_cmd} python-novaclient |grep -- '-packages/novaclient$'"
      out = %x[#{cmd}]

      if out.nil? or out.empty?
        Chef::Log.error("No stdout received for: #{cmd}")
        Chef::Log.fatal("Couldn't determine where to install SSLMiddleware")
      else
        Chef::Log.debug("Python#get_lib_path(): found #{out.chomp}")
      end

      # return parent dir (remove `novaclient')
      ::File.dirname(out)
    end
  end
end

::Chef::Recipe.send(:include, RCB::Python)
