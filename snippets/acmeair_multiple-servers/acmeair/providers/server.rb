action :install do

  liberty_dir = "#{node[:wlp][:base_dir]}/wlp"

  # create directories for shared resources and server definition
  ["#{liberty_dir}/usr/shared/resources/derby/",
   "#{liberty_dir}/usr/servers/#{new_resource.server_name}/",
   "#{liberty_dir}/usr/servers/#{new_resource.server_name}/apps/"].each do | name |
    directory name do
      mode 00775
      owner node[:wlp][:user]
      group node[:wlp][:group]
      action :create
      recursive true
    end
  end

  jenkins_base_url = "http://server:8080/job/AcmeAir%20tests/lastSuccessfulBuild/artifact"

  # mapping of remote resources to local files
  url_map = {
     "#{liberty_dir}/usr/shared/resources/derby/derby.jar" => "#{jenkins_base_url}/acmeair-itests/target/usr/shared/resources/derby/derby.jar",
     "#{liberty_dir}/usr/servers/#{new_resource.server_name}/server.xml" => "#{jenkins_base_url}/acmeair-itests/src/main/resources/servers/acmeair/server.xml",
     "#{liberty_dir}/usr/servers/#{new_resource.server_name}/bootstrap.properties" => "#{jenkins_base_url}/acmeair-itests/src/main/resources/servers/acmeair/bootstrap.properties",
     "#{liberty_dir}/usr/servers/#{new_resource.server_name}/apps/acmeair.war" => "#{jenkins_base_url}/acmeair-webapp/target/acmeair-webapp-1.0-SNAPSHOT.war"
  }

  # download each file and place it in right directory
  url_map.each do | file, url |
    remote_file file do
      source url
      user node[:wlp][:user]
      group node[:wlp][:group]
      action :create_if_missing
    end
  end

  wlp_bootstrap_properties "set bootstrap.properties" do
    server_name "#{new_resource.server_name}"
    properties "httpPort" => "#{new_resource.http_port_num}", "httpsPort" => "#{new_resource.https_port_num}"
    action :set
  end

  # start server if it is not running already
  wlp_server "#{new_resource.server_name}" do
    action :start
  end

  # populate the database
  bash "populate db" do
    user node[:wlp][:user]
    group node[:wlp][:group]
    code <<-EOH
    for retry in {1..10}
    do
      wget http://localhost:#{new_resource.http_port_num}/acmeair/rest/api/loader/loadSmall -O -
      if [ "$?" = 0 ]; then
        break
      else
        echo "Retrying ... attempt $retry"
        sleep 1
      fi
    done
    EOH
  end
end
