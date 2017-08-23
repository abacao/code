# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

	config.vm.define "ansible_server", primary: true do |ansible_server|
		ansible_server.vm.box = "centos/7"
		ansible_server.vm.synced_folder ".", "/vagrant", type: "virtualbox"
		ansible_server.vm.synced_folder "./ansible", "/home/vagrant/ansible", type: "virtualbox"
		ansible_server.vm.network "private_network", ip: "192.168.33.10"
		
		ansible_server.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--memory", 1024]
			vb.customize ["modifyvm", :id, "--cpus", 1]
		end

		$script = <<-SHELL
		#sudo yum update -y
		sudo yum install epel-release -y
		#sudo yum install nc -y
		sudo yum install ansible -y
		sudo chmod 400 /home/vagrant/.ssh/id_rsa
		sudo chmod 600 /home/vagrant/.ssh/config
		sudo mv bash_profile .bash_profile
		SHELL
		
		ansible_server.vm.provision "file", source: "./key/private_key.pem", destination: "/home/vagrant/.ssh/id_rsa"
		ansible_server.vm.provision "file", source: "./ansible_client/ssh/config", destination: "/home/vagrant/.ssh/config"
		ansible_server.vm.provision "file", source: "./ansible_client/.bash_profile", destination: "/home/vagrant/bash_profile"
		
		ansible_server.vm.provision "shell", inline: $script, env: {
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
			cat /home/vagrant/public_key.pub >> /home/vagrant/.ssh/authorized_keys 
			
			sudo yum update -y
			sudo yum install postgresql-server postgresql-contrib -y
			sudo postgresql-setup initdb
			systemctl start postgresql.service
			sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'MyPass123' ;"
		    # sudo systemctl enable firewalld
			# sudo systemctl start firewalld
			# sudo firewall-cmd --permanent --zone=trusted --add-source=192.168.33.0/24
			# sudo firewall-cmd --permanent --zone=trusted --add-port=5432/tcp
			# sudo systemctl reload firewalld
			sudo systemctl stop firewalld
			SHELL
			
			db.vm.provision "file", source: "./key/public_key.pub", destination: "/home/vagrant/public_key.pub"
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
		end
		$script = <<-SHELL
		cat /home/vagrant/public_key.pub >> /home/vagrant/.ssh/authorized_keys
					
		#TODO enable SE Linux
		sudo setenforce 0

		sudo yum update -y

		sudo yum install curl policycoreutils openssh-server openssh-clients -y
		sudo systemctl enable sshd
		sudo systemctl start sshd
		sudo yum install postfix
		sudo systemctl enable postfix
		sudo systemctl start postfix
		
		

		# systemctl enable firewalld
		# systemctl start firewalld
		# sudo firewall-cmd --permanent --add-service=http
		# sudo firewall-cmd --permanent --zone=trusted --add-source=192.168.33.0/24
		# sudo firewall-cmd --permanent --zone=trusted --add-port=6379/tcp
		# sudo firewall-cmd --permanent --zone=trusted --add-port=16379/tcp
		# sudo systemctl reload firewalld
		sudo systemctl stop firewalld	
		SHELL

		web.vm.provision "file", source: "./key/public_key.pub", destination: "/home/vagrant/public_key.pub"
		web.vm.provision "shell", inline: $script, env: {
		}
	end

end
