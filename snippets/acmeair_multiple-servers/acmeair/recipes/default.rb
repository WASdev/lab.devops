include_recipe "wlp::default"

servers = node[:acmeair][:servers][:application]

for server_num in 1..servers
  acmeair_server "create server acmeair#{server_num}" do
    server_name "acmeair#{server_num}"
    http_port_num 9080+server_num
    https_port_num 9443+server_num
    action :install
  end
end
