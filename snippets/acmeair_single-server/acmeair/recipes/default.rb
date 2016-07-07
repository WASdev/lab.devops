include_recipe "wlp::default"

acmeair_server "create server acmeair1" do
  server_name "acmeair1"
  action :install
end
