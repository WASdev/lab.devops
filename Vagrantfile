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

# -*- mode: ruby -*-
# vi: set ft=ruby :



$eclipse_desktop=<<SCRIPT
cat <<DESKTOP | sudo tee /usr/share/applications/eclipse.desktop
[Desktop Entry]
Name=Eclipse for Java EE Developers
Comment=IDE for all seasons
Exec=env UBUNTU_MENUPROXY=0 /usr/local/eclipse/eclipse
Icon=/usr/local/eclipse/icon.xpm
Terminal=false
Type=Application
Categories=Utility;Application;Development;IDE;
X-Desktop-File-Install-Version=0.22
DESKTOP
sudo desktop-file-install /usr/share/applications/eclipse.desktop
SCRIPT

$hosts=<<SCRIPT
cat <<HOSTS | sudo tee -a /etc/hosts

192.168.168.14 server
192.168.168.15 prod
192.168.168.16 workstation
HOSTS
SCRIPT

$conf=<<SCRIPT
cat <<CONF | sudo tee -a /etc/NetworkManager/NetworkManager.conf

[main]
plugins=ifupdown,keyfile,ofono
dns=dnsmasq

no-auto-default=00:0c:29:e3:07:34,

[ifupdown]
managed=false

CONF
SCRIPT

$docker=<<SCRIPT
cat <<DOCKER | sudo tee -a /etc/default/docker

DOCKER_OPTS="--insecure-registry server:5000 -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock"

DOCKER
SCRIPT

$chef_server=<<SCRIPT
sudo wget -q -N https://packages.chef.io/stable/ubuntu/14.04/chef-server-core_12.0.5-1_amd64.deb
sudo dpkg -i chef-server-core_*.deb
sudo chef-server-ctl reconfigure
sudo chef-server-ctl user-create admin admin admin admin@example.com examplepass -f /vagrant/admin.pem
sudo chef-server-ctl org-create liberty "liberty" --association_user admin -f /vagrant/liberty-validator.pem
SCRIPT

$sudoers=<<SCRIPT
echo %vagrant ALL=NOPASSWD:ALL > /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant
usermod -a -G sudo vagrant
SCRIPT

$chef_workstation=<<SCRIPT
sudo wget -q -N  https://packages.chef.io/stable/ubuntu/12.04/chefdk_0.10.0-1_amd64.deb
sudo dpkg -E-i chefdk*.deb
sudo chef generate repo /home/vagrant/chef-repo
sudo rm -rf /home/vagrant/chef-repo/cookbooks/example
mkdir /home/vagrant/.chef
sudo su -c 'berks install -b /vagrant/Berksfile-workstation' - vagrant
mv /home/vagrant/.berkshelf/cookbooks/application_wlp* /home/vagrant/chef-repo/cookbooks/application_wlp
mv /home/vagrant/.berkshelf/cookbooks/application* /home/vagrant/chef-repo/cookbooks/application
mv /home/vagrant/.berkshelf/cookbooks/wlp* /home/vagrant/chef-repo/cookbooks/wlp
mv /home/vagrant/.berkshelf/cookbooks/apt* /home/vagrant/chef-repo/cookbooks/apt
mv /home/vagrant/.berkshelf/cookbooks/java* /home/vagrant/chef-repo/cookbooks/java
sudo mv /vagrant/admin.pem /home/vagrant/.chef/
sudo mv /vagrant/liberty-validator.pem /home/vagrant/.chef/
sudo cp /vagrant/conf/knife.rb /home/vagrant/.chef/
sudo su -c 'sudo knife ssl fetch' vagrant
SCRIPT


Vagrant.configure(2) do |config|

  config.vm.define "server" do |server|
    server.vm.box = "ubuntu/trusty64"
    server.vm.hostname = "server"
    server.vm.provider "virtualbox" do |vb|
    #   # Display the VirtualBox GUI when booting the machine
       vb.gui = true
     #end
    #   # Customize the amount of memory on the VM:
       vb.memory = "2048"
     end
    server.vm.provision "shell" do |s|
      s.inline = "echo $1 : Downloading Chef Server... This may take a while"
      s.args = "$(date \"+%T\")"
    end
    server.vm.provision "shell", inline: $chef_server
    server.vm.network "private_network", ip: "192.168.168.14"
    server.vm.provision "shell", inline: "sudo apt-get update"
    server.vm.provision "shell", inline: "sudo apt-get install -y git"
    server.vm.provision "shell", inline: "sudo apt-get install -y maven"
    server.vm.provision "shell", inline: "sudo apt-get install -y lighttpd"
    server.vm.provision "shell", inline: "sudo mkdir -p /var/www/files"
    server.vm.provision "chef_solo" do |chef|
      chef.add_recipe "devops"
    end
    #server.vm.provision "shell", inline: "sudo /opt/ibm/wlp/bin/installUtility download --location=/var/www/files/liberty  --acceptLicense explore-1.0 collectiveController-1.0 clusterMember-1.0"
    server.vm.provision "shell", inline: "sudo su -c 'cp /vagrant/conf/org.jenkinsci.plugins.dockerbuildstep.DockerBuilder.xml /var/lib/jenkins' - jenkins"
    server.vm.provision "shell", inline: "sudo chmod 644 /var/lib/jenkins/org.jenkinsci.plugins.dockerbuildstep.DockerBuilder.xml"
    server.vm.provision "shell", inline: "sudo su -c 'cp /vagrant/conf/jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.xml /var/lib/jenkins' - jenkins"
    server.vm.provision "shell", inline: "sudo chmod 644 /var/lib/jenkins/jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.xml"
    server.vm.provision "shell", inline: "sudo su -c 'mkdir /var/lib/jenkins/.ssh' - jenkins"
    server.vm.provision "shell", inline: "sudo cp /vagrant/keys/id_rsa* /var/lib/jenkins/.ssh"
    server.vm.provision "shell", inline: "sudo su -c 'ssh-keyscan -H server >> /var/lib/jenkins/.ssh/known_hosts'"
    server.vm.provision "shell", inline: "sudo chown jenkins:jenkins /var/lib/jenkins/.ssh/id_rsa*"
    server.vm.provision "shell", inline: "cat /var/lib/jenkins/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys"
    server.vm.provision "shell", inline: "sudo chmod 600 /var/lib/jenkins/.ssh/id_rsa"
    server.vm.provision "shell", inline: "sudo chmod 644 /var/lib/jenkins/.ssh/id_rsa.pub"
    server.vm.provision "shell", inline: "sudo service jenkins restart"
    server.vm.provision "shell", inline: "git clone --mirror https://github.com/WASdev/sample.acmeair /home/vagrant/acmeair.git"
    server.vm.provision "shell", inline: "wget -N -O /var/www/files/index.yml http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/index.yml"

    server.vm.provision "docker" do |d|
      d.run "registry:2",
        args: "-d -p 5000:5000 --restart=always --name registry"
      d.pull_images "websphere-liberty:kernel"
      d.build_image "/vagrant/lars-docker",
        args: "-t lars"
      d.run "lars",
        args: "-d -p 9080:9080 -p 9443:9443 --name lars"
      d.run "mongo",
        args: "-d --net=container:lars"
    end





    server.vm.provision "shell", inline: "sudo docker tag websphere-liberty:kernel server:5000/websphere-liberty:kernel"
    server.vm.provision "shell", inline: "docker push server:5000/websphere-liberty"
    server.vm.provision "shell", inline: "docker exec lars populate 'jsp-2.2 localConnector-1.0 jpa-2.0 jaxrs-1.1 clusterMember-1.0 collectiveController-1.0 explore-1.0 websocket-1.1'"
    server.vm.provision "shell", inline: $docker
    server.vm.provision "shell", inline: "sudo usermod -aG docker jenkins"
    server.vm.provision "shell", inline: "sudo service docker restart"
    server.vm.provision "file", source: "conf/rc.local", destination: "/tmp/rc.local"
    server.vm.provision "shell", inline: "sudo mv /tmp/rc.local /etc/rc.local | chmod 755 /etc/rc.local | chown root:root /etc/rc.local"
    server.vm.provision "shell", inline: $hosts

  end

  config.vm.define "prod" do |prod|
    prod.vm.box = "ubuntu/trusty64"
    prod.vm.hostname = "prod"
    prod.vm.provider "virtualbox" do |vb|
    #   # Display the VirtualBox GUI when booting the machine
       vb.gui = true
     #end
    #   # Customize the amount of memory on the VM:
       vb.memory = "2048"
     end
     prod.vm.provision "docker"
     prod.vm.provision "shell", inline: $docker
     prod.vm.network "private_network", ip: "192.168.168.15"
     prod.vm.provision "shell", inline: $hosts
     prod.vm.provision "shell", inline: "cat /vagrant/keys/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys"
     prod.vm.provision "shell", inline: $sudoers

   end

   config.vm.define "workstation" do |workstation|
     workstation.vm.box = "ubuntu/trusty64"
     workstation.vm.hostname = "workstation"
      workstation.vm.provider "virtualbox" do |vb|
     #   # Display the VirtualBox GUI when booting the machine
        vb.gui = true
      #end
     #   # Customize the amount of memory on the VM:
        vb.memory = "4096"
        vb.cpus = 2
        vb.customize ["modifyvm", :id, "--vram", "128"]
        vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
      end

      workstation.vm.network "private_network", ip: "192.168.168.16"
      workstation.vm.provision "shell", inline: "sudo apt-get -y update"
      workstation.vm.provision "shell", inline: "sudo apt-get -y install ubuntu-desktop"
      workstation.vm.provision "chef_solo" do |chef|
        chef.add_recipe "devops"
      end

     workstation.vm.provision "shell", inline: "sudo /opt/ibm/wlp/bin/installUtility install --acceptLicense jsp-2.2 jpa-2.0 jaxrs-1.1"
     workstation.vm.provision "shell", inline: $eclipse_desktop
     workstation.vm.provision "file", source: "conf/rc.local", destination: "/tmp/rc.local"
     workstation.vm.provision "shell", inline: "sudo mv /tmp/rc.local /etc/rc.local | chmod 755 /etc/rc.local | chown root:root /etc/rc.local"
     workstation.vm.provision "shell", inline: $hosts
     workstation.vm.provision "shell", inline: "sudo cp /vagrant/keys/id_rsa* /home/vagrant/.ssh/"
     workstation.vm.provision "shell" do |s|
       s.inline = "echo $1 : Downloading ChefDK... This may take a while"
       s.args = "$(date \"+%T\")"
     end
     workstation.vm.provision "shell", inline: $chef_workstation
     #workstation.vm.provision "shell", inline: "gsettings set com.canonical.Unity.Launcher favorites \"['application://ubiquity.desktop', 'application://gnome-terminal.desktop', 'application://eclipse.desktop', 'application://nautilus.desktop', 'application://firefox.desktop']\""
     workstation.vm.provision "shell", inline: "sudo dbus-launch gsettings set org.gnome.desktop.session idle-delay 0"
     workstation.vm.provision "shell", inline: "sudo dbus-launch gsettings set org.gnome.desktop.screensaver lock-enabled false"
     workstation.vm.provision "file", source: "snippets", destination: "/home/vagrant/snippets"
     workstation.vm.provision "shell", inline: $conf
     workstation.vm.provision "shell", inline: "sudo rm -f /etc/xdg/autostart/update-notifier.desktop"


   end

end
