include_recipe "wlp::default"

# determines whether or not to create a collective
collective = node[:acmeair][:servers][:collective]
servers = node[:acmeair][:servers][:application]

#using the repositories_properties recipe to configure installUtility to use LARS
include_recipe "wlp::repositories_properties"

# create an additional server acmeair0 to be controller if collective is required
if collective == 1
  acmeair_controller "acmeair controller" do
    server_name "acmeair0"
    http_port_num 9080
    https_port_num 9443
    action :install
  end
end

for server_num in 1..servers
  acmeair_server "create server acmeair#{server_num}" do
    server_name "acmeair#{server_num}"
    http_port_num 9080+server_num
    https_port_num 9443+server_num
    controller_port_num 9443
    action :install
  end
end
