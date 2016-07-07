#lab.devops

This sample provides the means to create the VM images for an open source DevOps tool chain using WebSphere Liberty. As well as WebSphere Liberty the tutorial makes use of Eclipse, [WebSphere Developer Tools](http://marketplace.eclipse.org/search/site/%2522wdt%2522), [LARS](http://github.com/wasdev/tool.lars) with Apache Maven, Git, Jenkins, Docker|Chef.

This project started as 'we need to generate our 3 VM images we use in our DevOps lab so we can update the s/w inside the images really easily'. We knew Vagrant does that so that's what we have here.

1. Download and install Vagrant from https://www.vagrantup.com/downloads.html I put mine in C:\HashiCorp\Vagrant I used v1.7.4
1. Download and install ChefDK from https://downloads.chef.io/chef-dk/ I used v0.10.0
1. Download and install VirtualBox from https://www.virtualbox.org/wiki/Downloads I used v5.0.10
1. Download and install Git from https://git-scm.com/downloads I used v2.6.4
1. Ensure `ssh.exe` is in your path by adding `C:\Program Files\Git\usr\bin;` to the `PATH` environment variable.
1. Run ChefDK as administrator - 'Windows key' then 'chef' then right click 'Chef Development Kit' and click 'Run as administrator'. That will start a PowerShell.
1. Clone this repo. 
1. `vagrant plugin install vagrant-berkshelf` For more on Berkshelf see: [berkshelf.com](http://berkshelf.com/)
1. `vagrant up`

If you need to debug you'll want to run `vagrant ssh` to get into the VM and retrieve Chef logs or other logs.

There's a strange glitch when the `workstation` VM is created. The `dpkg` command has some issues updating some packages and we get this message:

`==> workstation: Sub-process /usr/bin/dpkg returned an error code (1)`

After which just run this to get things going again:

`vagrant reload --provision workstation`

# License

We use the [Apache 2.0 License](https://github.com/WASdev/lab.devops/blob/master/LICENSE)

# Contributing

We accept contributions. Please see our [How to contribute page](https://github.com/WASdev/wasdev.github.io/blob/master/CONTRIBUTING.md)

# Dependencies

This is really important. When you run Vagrant, all sorts of software will be downloaded. You'll get Ubuntu and all that comes with that. Then you'll get the following in one or more of the 3 VMs that are created:

| **Dependency**   | **Version** | **License**                                                    | **Source**                                        | **license page**                                                                                   |
|------------------|-------------|----------------------------------------------------------------|---------------------------------------------------|----------------------------------------------------------------------------------------------------|
| Chef Server Core | 12.0.5      | Apache-2.0                                                     | https://web-dl.packagecloud.io                    | https://downloads.chef.io/chef-server/12.6.0/ubuntu/14.04/license.html                             |
| ChefDK           | 0.10.0      | Apache-2.0                                                     | https://opscode-omnibus-packages.s3.amazonaws.com | https://downloads.chef.io/chef-dk/0.13.21/ubuntu/12.04-13.10-14.04/license.html                    |
| Docker           | Latest      | Apache-2.0                                                     | Downloaded and installed by vagrant provisioner   | https://www.docker.com/components-licenses                                                         |
| Eclipse Mars     | 4.5.1       | Eclipse Public License - v 1.0                                 | http://www.eclipse.org/downloads                  | https://www.eclipse.org/legal/epl-v10.html                                                         |
| Git              | Latest      | GNU v2                                                         | Ubuntu apt-get repo                               | https://git-scm.com/about/free-and-open-source                                                     |
| Jenkins          | Latest      | MIT                                                            | Ubuntu apt-get repo                               | https://jenkins.io/license/                                                                        |
| Lighttpd         | Latest      | Revised BSD                                                    | Ubuntu apt-get repo                               | https://www.lighttpd.net/                                                                          |
| Maven            | Latest      | Apache-2.0                                                     | Ubuntu apt-get repo                               | https://www.apache.org/licenses/                                                                   |
| OpenJDK          | Latest      | GNU v2                                                         | Ubuntu apt-get repo                               | http://openjdk.java.net/legal/gplv2+ce.html                                                        |
| Ubuntu 14.04     | 14.04       | Various                                                        | atlas.hashicorp.com                               | http://www.ubuntu.com/about/about-ubuntu/licensing                                                 |
| Ubuntu-Desktop   | Latest      | Various                                                        | Ubuntu apt-get repo                               | http://www.ubuntu.com/about/about-ubuntu/licensing                                                 |
| WDT              | Latest      | IBM International License Agreement for Non-Warranted Programs | http://public.dhe.ibm.com/ibmdl                   | https://developer.ibm.com/wasdev/downloads/#asset/tools-WebSphere_Developer_Tools_for_Eclipse_Mars |
| WLP              | Latest      | IBM International License Agreement for Non-Warranted Programs | http://public.dhe.ibm.com/ibmdl                   | https://developer.ibm.com/wasdev/downloads/#asset/runtimes-wlp-javaee7                             |
|                  |             |                                                                |                                                   |                                                                                                    |
| **Cookbooks**    |             |                                                                |                                                   |                                                                                                    |
|                  |             |                                                                |                                                   |                                                                                                    |
| Application      | 4.1.6       | Apache-2.0                                                     | Chef Supermarket                                  | https://supermarket.chef.io/cookbooks/application                                                  |
| Application_wlp  | 0.2.0       | Apache-2.0                                                     | Chef Supermarket                                  | https://supermarket.chef.io/cookbooks/application_wlp                                              |
| Ark              | 0.8.2       | Apache-2.0                                                     | Chef Supermarket                                  | https://supermarket.chef.io/cookbooks/ark                                                          |
| eclipse          | latest      | Apache-2.0                                                     | https://github.com/geocent-cookbooks/eclipse.git  | https://github.com/geocent-cookbooks/eclipse/blob/master/LICENSE                                   |
| Java             | 1.35        | Apache-2.0                                                     | Chef Supermarket                                  | https://supermarket.chef.io/cookbooks/java                                                         |
| Jenkins          | 2.4.1       | Apache-2.0                                                     | Chef Supermarket                                  | https://supermarket.chef.io/cookbooks/jenkins                                                      |
| wlp              | latest      | Apache-2.0                                                     | Chef Supermarket                                  | https://supermarket.chef.io/cookbooks/wlp                                                          |
