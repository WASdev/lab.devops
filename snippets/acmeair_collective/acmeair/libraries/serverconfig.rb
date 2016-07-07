# Cookbook Name:: acmeair
# Attributes:: default
#
# (C) Copyright IBM Corporation 2013, 2015.
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

require "rexml/document"

module Liberty
  module Server
    class Config
    
      attr_accessor :doc
      attr_accessor :modified

      def initialize(utils, serverName, doc)
        @utils = utils
        @serverName = serverName
        @doc = doc
        @modified = false
      end

      def self.load(node, serverName)
	Chef::Log.info("load entry")
        utils = Liberty::Utils.new(node)
        serverXml = "#{utils.serversDirectory}/#{serverName}/server.xml"
        f = File.open(serverXml)
        doc = REXML::Document.new(f)
        f.close
        return Config.new(utils, serverName, doc)
      end
      
      def save()
        serverXmlNew = "#{@utils.serversDirectory}/#{@serverName}/server.xml.new"
        out = File.open(serverXmlNew, "w")
        formatter = REXML::Formatters::Pretty.new
        formatter.compact = true
        formatter.write(@doc, out)
        out.close
        
        @utils.chown(serverXmlNew)

        serverXml = "#{@utils.serversDirectory}/#{@serverName}/server.xml"
        FileUtils.mv(serverXmlNew, serverXml)
      end
      
      def include(location)
        return Include.new(self, location)
      end

      def feature(name)
        return Feature.new(self, name)
      end
      
    end
    
    class Include
      
      def initialize(parent, location)
        @parent = parent
        
        @include = @parent.doc.root.elements["include[@location='#{location}']"]
        if ! @include 
          @include = REXML::Element.new("include")
          @include.attributes["location"] = location
          @parent.doc.root << @include
          @parent.modified = true
        end
        
      end
      
    end

    class Feature
      
      def initialize(parent, name)
        @parent = parent
        
        @feature = @parent.doc.root.elements["//featureManager"].elements["//feature[text() = '#{name}']"]
        if ! @feature 
          @feature = REXML::Element.new("feature")
          @feature.add_text("#{name}")
          @parent.doc.root.elements["//featureManager"] << @feature
          @parent.modified = true
        end
        
      end
      
    end
    
  end
end

