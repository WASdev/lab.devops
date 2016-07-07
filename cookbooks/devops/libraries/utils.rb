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

module Devops
  class Utils

    def initialize(node)
      @node = node.to_hash
    end

    def autoVersionZipUrl
      require 'open-uri'
      version_yml  = YAML::load(open(@node['wlp']['archive']['version_yaml']))
      web_version = @node['wlp']['webprofile']['version']
      java_version = @node['wlp']['java']['version']

      use_beta = @node['wlp']['archive']['use_beta']

      zip_uri = ''
      version_yml.each do |key, value|
        if !use_beta && key.start_with?('8.5')
          zip_uri = ::URI.parse(value["kernel"])
          # The newest version is the first one listed so break out after the first
          break
        end
        if use_beta && key.start_with?('20')
          runtime_uri = ::URI.parse(value["kernel"])
          break
        end
      end
      zip = "#{zip_uri}"
      zip.sub!('-kernel-', "-webProfile#{web_version}-java#{java_version}-linux-x86_64-")


      return "#{zip}"
    end
  end
end
