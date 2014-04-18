#
# Cookbook Name:: openstack-ssl
# Attributes:: default
#
# Copyright 2012-2014, Rackspace US, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

case platform_family
when "rhel"
  default["ssl"]["cert_path"] = "/etc/pki/tls"
when "debian"
  default["ssl"]["cert_path"] = "/etc/ssl"
end

default["ssl"]["default_pkey"] = File.join(
  node['ssl']['cert_path'], 'private', 'rpc-dist.key')

default["ssl"]["default_cert"] = File.join(
  node['ssl']['cert_path'], 'certs', 'rpc-dist.pem')

default["ssl"]["default_cacert"] = nil
