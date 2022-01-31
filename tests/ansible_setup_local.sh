#!/bin/bash
#DESC: Setup and configure Ansible control node
#WHO: chris@bitbull.ch
#DATE: 20211229


test -f /etc/os-release
if [ $? -ne 0 ]
then
  echo "ERROR: /etc/os-release missing"
  exit 1
fi

source /etc/os-release
echo "INFO: determine OS type now"
case "$ID" in 
  centos|almalinux|rocky)
    os_type="rel_clone"
    ;;
  rhel)
    os_type="rel"
    ;;
esac

echo "INFO: determine OS version now"
case "$VERSION_ID" in 
  7*)
    os_ver=7
    ;;
  8*)
    os_ver=8
    ;;
  9*)
    os_ver=9
    ;;
esac

echo "DEBUG: os_type=$os_type os_ver=$os_ver"

if [ "$os_type$os_ver" == "rel_clone7"  ] #########################################################
then
  for PKG in epel-release git wget curl ansible
  do
     rpm -q $PKG >/dev/null 2>&1 && echo $PKG is already installed || yum -y install $PKG
  done
  ansibleconfigfile="/etc/ansible/ansible.cfg"
  sed -i 's|^#inventory .*|inventory      = /etc/ansible/hosts|g' $ansibleconfigfile
  sed -i 's|^#roles_path .*|roles_path    = /etc/ansible/roles|g' $ansibleconfigfile
  sed -i 's|^#remote_user .*|remote_user = root|g' $ansibleconfigfile
  sed -i 's|^#nocows .*|nocows = 1|g' $ansibleconfigfile
  sed -i "/^roles_path/a\ \n#additional paths to search for collections in, colon separated\ncollections_paths = /etc/ansible/collections" $ansibleconfigfile
  test -d /etc/ansible/projects || mkdir /etc/ansible/projects ; chmod 700 /etc/ansible/projects
  test -d /etc/ansible/collections || mkdir /etc/ansible/collections ; chmod 755 /etc/ansible/collections
  ansible-galaxy search joe-speedboat | cat

elif [ "$os_type$os_ver" == "rel_clone8"  ] #########################################################
then
  dnf -y config-manager --set-enabled powertools
  for PKG in epel-release git wget curl ansible
  do
     rpm -q $PKG >/dev/null 2>&1 && echo $PKG is already installed || dnf -y install $PKG
  done
  ansibleconfigfile="/etc/ansible/ansible.cfg"
  sed -i 's|^#inventory .*|inventory      = /etc/ansible/hosts|g' $ansibleconfigfile
  sed -i 's|^#roles_path .*|roles_path    = /etc/ansible/roles|g' $ansibleconfigfile
  sed -i 's|^#remote_user .*|remote_user = root|g' $ansibleconfigfile
  sed -i 's|^#nocows .*|nocows = 1|g' $ansibleconfigfile
  sed -i "/^roles_path/a\ \n#additional paths to search for collections in, colon separated\ncollections_paths = /etc/ansible/collections" $ansibleconfigfile

  test -d /etc/ansible/projects || mkdir /etc/ansible/projects ; chmod 700 /etc/ansible/projects
  test -d /etc/ansible/collections || mkdir /etc/ansible/collections ; chmod 755 /etc/ansible/collections
  ansible-galaxy search joe-speedboat | cat

elif [ "$os_type$os_ver" == "rel8"  ] #########################################################
then
  subscription-manager register | grep -q 'system is already registered'
  if [ $? -ne 0 ]
  then
    echo "ERROR: System is not registered in RHN"
    exit 1
  fi
  subscription-manager repos --enable codeready-builder-for-rhel-8-$(arch)-rpms
  dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
  for PKG in epel-release git wget curl ansible
  do
     rpm -q $PKG >/dev/null 2>&1 && echo $PKG is already installed || dnf -y install $PKG
  done
  ansibleconfigfile="/etc/ansible/ansible.cfg"
  sed -i 's|^#inventory .*|inventory      = /etc/ansible/hosts|g' $ansibleconfigfile
  sed -i 's|^#roles_path .*|roles_path    = /etc/ansible/roles|g' $ansibleconfigfile
  sed -i 's|^#remote_user .*|remote_user = root|g' $ansibleconfigfile
  sed -i 's|^#nocows .*|nocows = 1|g' $ansibleconfigfile
  sed -i "/^roles_path/a\ \n#additional paths to search for collections in, colon separated\ncollections_paths = /etc/ansible/collections" $ansibleconfigfile

  test -d /etc/ansible/projects || mkdir /etc/ansible/projects ; chmod 700 /etc/ansible/projects
  test -d /etc/ansible/collections || mkdir /etc/ansible/collections ; chmod 755 /etc/ansible/collections
  ansible-galaxy search joe-speedboat | cat

elif [ "$os_type$os_ver" == "rel_clone9"  ] #########################################################
then
  dnf -y config-manager --set-enabled crb
  for PKG in https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm  https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm git wget curl ansible-core
  do
     rpm -q $PKG >/dev/null 2>&1 && echo $PKG is already installed || dnf -y install $PKG
  done
  ansibleconfigfile="/etc/ansible/ansible.cfg"
  test -d /etc/ansible || mkdir /etc/ansible ; chmod 755 /etc/ansible
  test -d /etc/ansible/projects || mkdir /etc/ansible/projects ; chmod 700 /etc/ansible/projects
  test -d /etc/ansible/collections || mkdir /etc/ansible/collections ; chmod 755 /etc/ansible/collections
  test -f $ansibleconfigfile && cp -anv $ansibleconfigfile $ansibleconfigfile.bak
  ansible-config init --disabled -t all > $ansibleconfigfile
  sed -i 's|^;inventory=|inventory=|' $ansibleconfigfile
  sed -i 's|^;roles_path=|roles_path=|' $ansibleconfigfile
  sed -i 's|^;collections_path=|collections_path=|' $ansibleconfigfile
  sed -i 's|^;nocows=.*|nocows=True|' $ansibleconfigfile
  test -f /etc/ansible/hosts || echo localhost > /etc/ansible/hosts
  ansible-galaxy search joe-speedboat | cat
else
  echo "WARNING: No supported operating system found: os_type=$os_type os_ver=$os_ver"
fi
echo done
