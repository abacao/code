# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	config.vm.define "ans", primary: true do |ans|
			ans.vm.box = "ubuntu/xenial64"
			ans.vm.synced_folder ".", "/vagrant", type: "virtualbox"
			ans.vm.synced_folder ".", "/vagrantansible", type: "virtualbox"
			ans.vm.network "private_network", ip: "192.168.33.10"
			$script = <<-SHELL
			sudo apt-get update
			sudo apt-get upgrade -y

			sudo apt-get install ansible -y
			
			sudo chmod 400 /home/ubuntu/.ssh/ida_rsa
			sudo chmod 600 /home/ubuntu/.ssh/config
			sudo cp /home/ubuntu/hosts /etc/ansible/hosts
			
			
			SHELL
			
			ans.vm.provision "file", source: "./ansible/config", destination: "/home/ubuntu/.ssh/config"
			ans.vm.provision "file", source: "./ansible/hosts", destination: "/home/ubuntu/hosts"
			
			ans.vm.provision "shell", inline: $script, env: {
			}
	end

	config.vm.define "db" do |db|
		db.vm.box = "centos/7"
		db.vm.synced_folder ".", "/vagrant", type: "virtualbox"
		db.vm.network "private_network", ip: "192.168.33.11"
		db.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--memory", 1024]
			vb.customize ["modifyvm", :id, "--cpus", 1]
		end
		
		$script = <<-SHELL
		sudo yum update -y
		sudo yum install postgresql-server postgresql-contrib -y
		sudo postgresql-setup initdb
	
		SHELL
		

		db.vm.provision "shell", inline: $script, env: {
		}
	end

	config.vm.define "web-1" do |web|
		web.vm.box = "centos/7"
		web.vm.synced_folder ".", "/vagrant", type: "virtualbox"
		web.vm.network "private_network", ip: "192.168.33.21"
		web.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--memory", 2048]
			vb.customize ["modifyvm", :id, "--cpus", 2]
			#vb.gui  = true
		end
		$script = <<-SHELL
			
		sudo setenforce 0

		
		sudo yum update -y

		sudo yum install curl policycoreutils openssh-server openssh-clients -y
		sudo systemctl enable sshd
		sudo systemctl start sshd
		sudo yum install postfix
		sudo systemctl enable postfix
		sudo systemctl start postfix

		systemctl enable firewalld
		systemctl start firewalld
		sudo firewall-cmd --permanent --add-service=http
		sudo firewall-cmd --permanent --zone=trusted --add-source=192.168.33.0/24
		sudo firewall-cmd --permanent --zone=trusted --add-port=6379/tcp
		sudo firewall-cmd --permanent --zone=trusted --add-port=16379/tcp
		sudo systemctl reload firewalld
		



		
		SHELL

		web.vm.provision "file", source: "./gitlab_conf/gitlab.rb", destination: "~/gitlab.rb"
		web.vm.provision "file", source: "./gitlab_conf/gitlab-secrets.json", destination: "~/gitlab-secrets.json"

		web.vm.provision "shell", inline: $script, env: {
		}
end
	config.vm.define "web-2" do |web|
		web.vm.box = "centos/7"
		web.vm.synced_folder ".", "/vagrant", type: "virtualbox"
		web.vm.network "private_network", ip: "192.168.33.22"
		web.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--memory", 2048]
			vb.customize ["modifyvm", :id, "--cpus", 2]
			#vb.gui  = true
		end
		$script = <<-SHELL
			
		sudo setenforce 0
		
		sudo yum update -y

		sudo yum install curl policycoreutils openssh-server openssh-clients -y
		sudo systemctl enable sshd
		sudo systemctl start sshd
		sudo yum install postfix
		sudo systemctl enable postfix
		sudo systemctl start postfix
		

   	systemctl disable firewalld
		systemctl stop firewalld
		sudo firewall-cmd --permanent --add-service=http
		sudo firewall-cmd --permanent --zone=trusted --add-source=192.168.33.0/24
		sudo firewall-cmd --permanent --zone=trusted --add-port=6379/tcp
		sudo firewall-cmd --permanent --zone=trusted --add-port=16379/tcp
		sudo systemctl reload firewalld
		SHELL

		web.vm.provision "file", source: "./gitlab_conf/gitlab.rb", destination: "~/gitlab.rb"
		web.vm.provision "file", source: "./gitlab_conf/gitlab-secrets.json", destination: "~/gitlab-secrets.json"
		web.vm.provision "shell", inline: $script, env: {
		}
end



end

  #vagrant plugin install vagrant-vbguest
  #psql -h localhost -p 5432 postgres
  #sudo -u postgres psql -c "\l" gitlab_dev