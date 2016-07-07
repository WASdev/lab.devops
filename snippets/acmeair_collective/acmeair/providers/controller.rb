action :install do

  liberty_dir = "#{node[:wlp][:base_dir]}/wlp"

  # create directories for shared resources and server definition
  ["#{liberty_dir}/usr/shared/resources/derby/",
   "#{liberty_dir}/usr/servers/#{new_resource.server_name}/"].each do | name |
    directory name do
      mode 00775
      owner node[:wlp][:user]
      group node[:wlp][:group]
      action :create
      recursive true
    end
  end

  jenkins_base_url = "http://server:8080/job/AcmeAir%20tests/lastSuccessfulBuild/artifact"

  wlp_bootstrap_properties "set bootstrap.properties" do
    server_name "#{new_resource.server_name}"
    properties "httpPort" => "#{new_resource.http_port_num}", "httpsPort" => "#{new_resource.https_port_num}"
    action :set
  end

  # define service beforehand - otherwise notifications from ruby_block won't work
  #service "wlp-#{new_resource.server_name}" do
    #supports :start => true, :restart => true, :stop => true, :status => true
   # action :nothing
  #end



  # installing features using installUtility
  wlp_install_feature "collective features" do
    name "clusterMember-1.0 collectiveController-1.0 explore-1.0 websocket-1.1"
    accept_license true
    action :install
  end

  # configure controller server
  wlp_server "#{new_resource.server_name}" do
    config ({
      "featureManager" => {
        "feature" => [ "adminCenter-1.0", "collectiveController-1.0" ]
      },
      # this file is created by the wlp_collective create
      "include" => {
        "location" => "${server.config.dir}/controller.xml"
      },
      "httpEndpoint" => {
        "id" => "defaultHttpEndpoint",
        "host" => "*",
        "httpPort" => "#{new_resource.http_port_num}",
        "httpsPort" => "#{new_resource.https_port_num}"
      }
    })
    action :create
  end

  wlp_collective "#{new_resource.server_name}" do
    action :create
    server_name #{new_resource.server_name}
    keystorePassword "Liberty"
    admin_user "admin"
    admin_password "adminpwd"
  end

  # start server if it is not running already
  wlp_server "#{new_resource.server_name}" do
    action :start
  end

end
