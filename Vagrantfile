# -*- mode: ruby -*-
# vi: set ft=ruby :

default_vm_box = "bento/centos-7.4"
default_vm_box_version = "201709.15.0"
default_vm_mem = "1024"
default_vm_mem_tiny = "256"

Vagrant.configure("2") do |config|

	config.vm.define "ansible_server", primary: true do |ansible_server|
		ansible_server.vm.box = "#{default_vm_box}"
		ansible_server.vm.box_version = "#{default_vm_box_version}"
		ansible_server.vm.synced_folder ".", "/vagrant", type: "virtualbox"
		ansible_server.vm.synced_folder "./ansible", "/home/vagrant/ansible", type: "virtualbox"
		ansible_server.vm.network "private_network", ip: "192.168.33.10"
		ansible_server.vm.hostname = "ansibleserver"

		ansible_server.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--name", "ansible_server"]
			vb.customize ["modifyvm", :id, "--memory", "#{default_vm_mem_tiny}"]
			vb.customize ["modifyvm", :id, "--cpus", 1]
		end

		$script = <<-SHELL
		#sudo yum update -y
		sudo yum install epel-release -y
		sudo yum install ansible -y
		sudo chmod 400 /home/vagrant/.ssh/id_rsa
		sudo chmod 600 /home/vagrant/.ssh/config
		sudo mv bash_profile .bash_profile
		export ANSIBLE_HOST_KEY_CHECKING=False
		SHELL

		ansible_server.vm.provision "file", source: "./key/private_key.pem", destination: "/home/vagrant/.ssh/id_rsa"
		ansible_server.vm.provision "file", source: "./ansible_client/ssh/config", destination: "/home/vagrant/.ssh/config"
		ansible_server.vm.provision "file", source: "./ansible_client/.bash_profile", destination: "/home/vagrant/bash_profile"

		ansible_server.vm.provision "shell", inline: $script, env: {
		}
	end


	config.vm.define "db1" do |db|
			db.vm.box = "#{default_vm_box}"
			db.vm.box_version = "#{default_vm_box_version}"
			db.vm.synced_folder ".", "/vagrant", type: "virtualbox"
			db.vm.network "private_network", ip: "192.168.33.11"
			db.vm.hostname = "db1"
			db.vm.provider :virtualbox do |vb|
				vb.customize ["modifyvm", :id, "--memory", "#{default_vm_mem_tiny}"]
				vb.customize ["modifyvm", :id, "--cpus", 1]
			end

			$script = <<-SHELL
			cat /home/vagrant/public_key.pub >> /home/vagrant/.ssh/authorized_keys

			sudo yum update -y
			sudo yum install postgresql-server postgresql-contrib epel-release -y
			sudo postgresql-setup initdb
			systemctl start postgresql.service
			sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'MyPass123' ;"
			sudo systemctl stop firewalld
			SHELL

			db.vm.provision "file", source: "./key/public_key.pub", destination: "/home/vagrant/public_key.pub"
			db.vm.provision "shell", inline: $script, env: {
			}

	end

	config.vm.define "db2" do |db|
			db.vm.box = "#{default_vm_box}"
			db.vm.box_version = "#{default_vm_box_version}"
			db.vm.synced_folder ".", "/vagrant", type: "virtualbox"
			db.vm.network "private_network", ip: "192.168.33.12"
			db.vm.hostname = "db2"
			db.vm.provider :virtualbox do |vb|
				vb.customize ["modifyvm", :id, "--memory", "#{default_vm_mem_tiny}"]
				vb.customize ["modifyvm", :id, "--cpus", 1]
			end

			$script = <<-SHELL
			cat /home/vagrant/public_key.pub >> /home/vagrant/.ssh/authorized_keys

			sudo yum update -y
			sudo yum install postgresql-server postgresql-contrib epel-release -y
			sudo postgresql-setup initdb
			systemctl start postgresql.service
			sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'MyPass123' ;"
			sudo systemctl stop firewalld
			SHELL

			db.vm.provision "file", source: "./key/public_key.pub", destination: "/home/vagrant/public_key.pub"
			db.vm.provision "shell", inline: $script, env: {
			}

	end

	config.vm.define "gitlab1" do |web|
		web.vm.box = "#{default_vm_box}"
		web.vm.box_version = "#{default_vm_box_version}"
		web.vm.synced_folder ".", "/vagrant", type: "virtualbox"
		web.vm.network "private_network", ip: "192.168.33.21"
		web.vm.hostname = "web1.codes.siemens.poc"
		web.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--memory", "#{default_vm_mem}"]
			vb.customize ["modifyvm", :id, "--cpus", 1]
		end
		$script = <<-SHELL
		cat /home/vagrant/public_key.pub >> /home/vagrant/.ssh/authorized_keys

		#TODO enable SE Linux
		sudo setenforce 0
		sudo groupadd gitadm

		sudo yum update -y


		sudo yum install curl policycoreutils openssh-server openssh-clients epel-release -y
		sudo yum -y install python-pip
		sudo pip install pexpect

		sudo systemctl enable sshd
		sudo systemctl start sshd
		sudo yum install postfix
		sudo systemctl enable postfix
		sudo systemctl start postfix
		sudo systemctl stop firewalld
		SHELL

		web.vm.provision "file", source: "./key/public_key.pub", destination: "/home/vagrant/public_key.pub"
		web.vm.provision "shell", inline: $script, env: {
		}
	end

	config.vm.define "gitlab2" do |web|
		web.vm.box = "#{default_vm_box}"
		web.vm.box_version = "#{default_vm_box_version}"
		web.vm.synced_folder ".", "/vagrant", type: "virtualbox"
		web.vm.network "private_network", ip: "192.168.33.22"
		web.vm.hostname = "web1.codes.siemens.poc"
		web.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--memory", "#{default_vm_mem}"]
			vb.customize ["modifyvm", :id, "--cpus", 1]
		end
		$script = <<-SHELL
		cat /home/vagrant/public_key.pub >> /home/vagrant/.ssh/authorized_keys

		#TODO enable SE Linux
		sudo setenforce 0
		sudo groupadd gitadm

		sudo yum install curl policycoreutils openssh-server openssh-clients epel-release -y
		sudo yum update -y
		sudo yum -y install python-pip
		sudo pip install pexpect

		sudo systemctl enable sshd
		sudo systemctl start sshd
		sudo yum install postfix
		sudo systemctl enable postfix
		sudo systemctl start postfix
		sudo systemctl stop firewalld
		SHELL

		web.vm.provision "file", source: "./key/public_key.pub", destination: "/home/vagrant/public_key.pub"
		web.vm.provision "shell", inline: $script, env: {
		}
	end

end
