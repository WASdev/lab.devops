attribute :server_name, :kind_of => String, :default => nil
attribute :http_port_num, :kind_of => Integer, :default => 9081
attribute :https_port_num, :kind_of => Integer, :default => 9444
attribute :controller_port_num, :kind_of => Integer, :default => nil

actions :install
default_action :install
