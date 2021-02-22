#!/bin/bash
#DESC: Setup and configure Ansible control node
#WHO: chris@bitbull.ch
#DATE: 20210222

for PKG in git epel-release wget curl ansible
do
   rpm -q $PKG >/dev/null 2>&1 && echo $PKG is already installed || yum -y install $PKG
done

# ansible generic setup
ansibleconfigfile="/etc/ansible/ansible.cfg"
sed -i 's|^#inventory .*|inventory      = /etc/ansible/hosts|g' $ansibleconfigfile
sed -i 's|^#roles_path .*|roles_path    = /etc/ansible/roles|g' $ansibleconfigfile
sed -i 's|^#remote_user .*|remote_user = root|g' $ansibleconfigfile
sed -i 's|^#log_path .*|log_path = /var/log/ansible.log|g' $ansibleconfigfile
sed -i 's|^#nocows .*|nocows = 1|g' $ansibleconfigfile
sed -i "/^roles_path/a\ \n#additional paths to search for collections in, colon separated\ncollections_paths = /etc/ansible/collections" $ansibleconfigfile

test -d /etc/ansible/projects || mkdir /etc/ansible/projects ; chmod 700 /etc/ansible/projects
test -d /etc/ansible/collections || mkdir /etc/ansible/collections ; chmod 755 /etc/ansible/collections

ansible-galaxy search joe-speedboat
