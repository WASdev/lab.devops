attribute :server_name, :kind_of => String, :default => nil
attribute :http_port_num, :kind_of => Integer, :default => 9080
attribute :https_port_num, :kind_of => Integer, :default => 9443

actions :install
default_action :install
