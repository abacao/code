How to use the vagrant test environment

Place a custom keypair (private_key.pem, public_key.pub) into folder called "key".

On your local machine you should:
- `vagrant up`
- `vagrant ssh ansible_server`

Inside the Ansible Server machine:

- vagrant@ansible_server $ `export ANSIBLE_HOST_KEY_CHECKING=False`
- vagrant@ansible_server $ `cd ansible`
- vagrant@ansible_server $ `ansible-playbook deploy_database.yml -i hosts-dev`
- vagrant@ansible_server $ `ansible-playbook deploy_gitlab.yml -i hosts-dev`

GitLab can be opened via the browser: 192.168.33.21
