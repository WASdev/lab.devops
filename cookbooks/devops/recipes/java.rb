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

java_alternatives 'set-java-alternatives' do
  java_location node['java']['java_home']
  default node['java']['set_default']
  bin_cmds node['java']['ibm']['8']['bin_cmds']
end


execute "untar-ibm-java" do
  cwd Chef::Config[:file_cache_path]
  notifies :set, 'java_alternatives[set-java-alternatives]', :immediately
  creates "#{node['java']['java_home']}/jre/bin/java"
end

include_recipe "java::set_java_home"
