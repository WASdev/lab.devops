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

override['eclipse']['version'] = 'mars'
override['eclipse']['release_code'] = "1"
override['eclipse']['plugins'] = [{"http://download.eclipse.org/releases/mars"=>"org.eclipse.egit.feature.group"},
                                 {"http://download.eclipse.org/technology/m2e/releases"=>"org.eclipse.m2e.feature.feature.group"},
                                 {"http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/updates/wdt/mars"=>"com.ibm.websphere.wdt.server.tools.main.feature.group "}]
override[:wlp][:archive][:accept_license] = true
override[:wlp][:base_dir] = '/opt/ibm/'
override[:wlp][:user] = "wlp"
override[:wlp][:group] = "vagrant"
override[:wlp][:install_method] = 'zip'
override[:wlp][:install_java] = false
default[:wlp][:webprofile][:version] = '7'
default[:wlp][:java][:version] = '8'
override['java']['jdk_version'] = '7'
override['java']['java_home'] = '/opt/ibm/wlp/java/java'
default['java']['ibm']['8']['bin_cmds'] = [ "appletviewer", "idlj", "java", "javah", "javaw", "jcontrol", "jdmpview", "keytool", "policytool", "rmiregistry", "tnameserv", "wsimport",
                                          "ControlPanel", "jar", "javac", "javap", "javaws", "jdb", "jjs", "native2ascii", "rmic", "schemagen", "unpack200", "xjc", "extcheck",
                                          "jarsigner", "javadoc", "java-rmi.cgi", "jconsole", "jdeps", "jrunscript", "pack200", "rmid", "serialver", "wsgen" ]]
override[:jenkins][:master][:repository] = 'http://pkg.jenkins-ci.org/debian-stable'
override[:jenkins][:master][:repository_key] = 'http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key'
