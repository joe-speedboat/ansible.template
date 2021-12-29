#!/bin/bash
#DESC: Setup and configure Ansible control node
#WHO: chris@bitbull.ch
#DATE: 20211229

if dnf info ansible >/dev/null 2>&1
then
  echo "INFO: Found ansible rpm package, so I will install by dnf"
  for PKG in git epel-release wget curl ansible
  do
     rpm -q $PKG >/dev/null 2>&1 && echo $PKG is already installed || yum -y install $PKG
  done

  # ansible generic setup
  ansibleconfigfile="/etc/ansible/ansible.cfg"
  sed -i 's|^#inventory .*|inventory      = /etc/ansible/hosts|g' $ansibleconfigfile
  sed -i 's|^#roles_path .*|roles_path    = /etc/ansible/roles|g' $ansibleconfigfile
  sed -i 's|^#remote_user .*|remote_user = root|g' $ansibleconfigfile
  sed -i 's|^#nocows .*|nocows = 1|g' $ansibleconfigfile
  sed -i "/^roles_path/a\ \n#additional paths to search for collections in, colon separated\ncollections_paths = /etc/ansible/collections" $ansibleconfigfile

  test -d /etc/ansible/projects || mkdir /etc/ansible/projects ; chmod 700 /etc/ansible/projects
  test -d /etc/ansible/collections || mkdir /etc/ansible/collections ; chmod 755 /etc/ansible/collections
  ansible-galaxy search joe-speedboat

elif dnf info ansible-core >/dev/null 2>&1
then
  echo "INFO: Found ansible-core rpm package, so I will install ansible with pip"
  for PKG in git wget curl pip
  do
     rpm -q $PKG >/dev/null 2>&1 && echo $PKG is already installed || yum -y install $PKG
  done
  pip install ansible
  ansibleconfigfile="/etc/ansible/ansible.cfg"
  test -d /etc/ansible || mkdir /etc/ansible ; chmod 755 /etc/ansible
  test -d /etc/ansible/projects || mkdir /etc/ansible/projects ; chmod 700 /etc/ansible/projects
  test -d /etc/ansible/collections || mkdir /etc/ansible/collections ; chmod 755 /etc/ansible/collections

  ansible-config init --disabled -t all > $ansibleconfigfile

  sed -i 's|^;inventory=|inventory=|' $ansibleconfigfile
  sed -i 's|^;roles_path=|roles_path=|' $ansibleconfigfile
  sed -i 's|^;collections_path=|collections_path=|' $ansibleconfigfile
  sed -i 's|^;nocows=.*|nocows=True|' $ansibleconfigfile

  test -f /etc/ansible/hosts || echo localhost > /etc/ansible/hosts

  ansible-galaxy search joe-speedboat

fi
