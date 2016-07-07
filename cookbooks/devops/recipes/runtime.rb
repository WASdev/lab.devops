# Cookbook Name:: devops
# Attributes:: default
#
# (C) Copyright IBM Corporation 2016.
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

wlp_user = node[:wlp][:user]
wlp_group = node[:wlp][:group]
wlp_base_dir = node[:wlp][:base_dir]

unless node[:wlp][:archive][:accept_license]
  raise "You must accept the license to install WebSphere Application Server Liberty Profile."
end

# Don't create 'root' group - allows execution as root
if wlp_group != "root"
  group wlp_group do
  end
end

# Don't create 'root' user - allows execution as root
if wlp_user != "root"
  user wlp_user do
    comment 'Liberty Profile Server'
    gid wlp_group
    home wlp_base_dir
    shell '/bin/sh'
    system true
  end
end

directory wlp_base_dir do
  group wlp_group
  owner wlp_user
  mode "0755"
  recursive true
end

if node[:wlp][:archive][:runtime][:url] == nil
  utils = Liberty::Utils.new(node)
  urls = utils.autoVersionUrls
  node.default[:wlp][:archive][:runtime][:url] = urls[0]
  node.default[:wlp][:archive][:extended][:url] = urls[1]
  node.default[:wlp][:archive][:extras][:url] = urls[2]
end

runtime_uri = ::URI.parse(node[:wlp][:archive][:runtime][:url])
runtime_dir = "/var/www/files"
runtime_filename = ::File.basename(runtime_uri.path)

# Fetch the WAS Liberty Profile runtime file
if runtime_uri.scheme == "file"
  runtime_file = runtime_uri.path
else
  runtime_file = "#{runtime_dir}/#{runtime_filename}"
  remote_file runtime_file do
    source node[:wlp][:archive][:runtime][:url]
    user node[:wlp][:user]
    group node[:wlp][:group]
    #not_if { ::File.exists?(runtime_dir) }
  end
end

# Used to determine whether extended archive is already installed
extended_dir = "#{node[:wlp][:base_dir]}/bin/jaxws"

# Fetch the WAS Liberty Profile extended content
if node[:wlp][:archive][:extended][:install]
 extended_uri = ::URI.parse(node[:wlp][:archive][:extended][:url])
  extended_filename = ::File.basename(extended_uri.path)

  if extended_uri.scheme == "file"
    extended_file = extended_uri.path
  else
    extended_file = "#{runtime_dir}/#{extended_filename}"
    remote_file extended_file do
      source node[:wlp][:archive][:extended][:url]
      user node[:wlp][:user]
      group node[:wlp][:group]
      not_if { ::File.exists?(extended_dir) }
    end
  end
end
