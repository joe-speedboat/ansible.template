#!/bin/bash
#DESC: Setup and configure Ansible control node
# Copyright (c) Chris Ruettimann <chris@bitbull.ch>
# This software is licensed to you under the GNU General Public License.
# There is NO WARRANTY for this software, express or
# implied, including the implied warranties of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
# along with this software; if not, see
# http://www.gnu.org/licenses/gpl.txt

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
  8*)
    os_ver=8
    ;;
  9*)
    os_ver=9
    ;;
esac

echo "DEBUG: os_type=$os_type os_ver=$os_ver"

if [ "$os_type$os_ver" == "rel_clone8"  ] #########################################################
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
  test -d /etc/ansible/playbooks || mkdir /etc/ansible/playbooks ; chmod 700 /etc/ansible/playbooks
  test -d /etc/ansible/collections || mkdir /etc/ansible/collections ; chmod 755 /etc/ansible/collections
  ansible-galaxy search joe-speedboat | cat

elif [ "$os_type$os_ver" == "rel8"  ] #########################################################
then
  yes | subscription-manager register | grep -q 'system is already registered'
  if [ $? -ne 0 ]
  then
    echo "ERROR: System is not registered in RHN"
    exit 1
  fi
  subscription-manager repos --enable ansible-2.8-for-rhel-8-x86_64-rpms
  for PKG in git wget curl ansible
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
  test -d /etc/ansible/playbooks || mkdir /etc/ansible/playbooks ; chmod 700 /etc/ansible/playbooks
  test -d /etc/ansible/collections || mkdir /etc/ansible/collections ; chmod 755 /etc/ansible/collections
  ansible-galaxy search joe-speedboat | cat

elif [ "$os_type$os_ver" == "rel9"  ] #########################################################
then
  subscription-manager repos --enable=$(dnf repolist --all | awk '{print $1}' | grep -i codeready | grep $(echo $VERSION |cut -d. -f1)-$(arch)-rpms | tail -1)
  for PKG in git wget curl ansible-core
  do
     rpm -q $PKG >/dev/null 2>&1 && echo $PKG is already installed || dnf -y install $PKG
  done
  ansibleconfigfile="/etc/ansible/ansible.cfg"
  test -d /etc/ansible || mkdir /etc/ansible ; chmod 755 /etc/ansible
  test -d /etc/ansible/projects || mkdir /etc/ansible/projects ; chmod 700 /etc/ansible/projects
  test -d /etc/ansible/playbooks || mkdir /etc/ansible/playbooks ; chmod 700 /etc/ansible/playbooks
  test -d /etc/ansible/collections || mkdir /etc/ansible/collections ; chmod 755 /etc/ansible/collections
  test -f $ansibleconfigfile && cp -anv $ansibleconfigfile $ansibleconfigfile.bak
  ansible-config init --disabled -t all | sed -e 's|{{ ANSIBLE_HOME ~ "/|/etc/ansible/|g' -e 's|" }}||g' > $ansibleconfigfile
  sed -i 's|^;inventory=|inventory=|' $ansibleconfigfile
  sed -i 's|^;roles_path=|roles_path=|' $ansibleconfigfile
  sed -i 's|^;collections_path=|collections_path=|' $ansibleconfigfile
  sed -i 's|^;nocows=.*|nocows=True|' $ansibleconfigfile
  test -f /etc/ansible/hosts || echo localhost > /etc/ansible/hosts
  ansible-galaxy search joe-speedboat | cat

elif [ "$os_type$os_ver" == "rel_clone9"  ] #########################################################
then
  # install system wide python
  unset NPV ; PV=3.12 ; read -p  "Python version[$PV]: " NPV ; if [ "$NPV" ] ; then PV="$NPV" ; fi ; export PV="$PV"
  unset AU ; AU=ansible ; read -p  "Ansible Username[$AU]: " NAU ; if [ "$NAU" ] ; then AU="$NAU" ; fi ; export AU="$AU"
  unset SA ; SA=Y ; read -p  "Setup Ansible config in /etc/ansible[$SA]: " NSA ; if [ "$NSA" ] ; then SA="$NSA" ; fi ; export SA="$SA"

  PKG="git wget curl python${PV} python${PV}-pip"
  if [ "$USER" == "root" ]
  then
    echo INFO: User is root, installing $PKG
    dnf -y install $PKG || exit 1

    echo "INFO: Setup Ansible user: $AU"
    id $AU >/dev/null 2>1 || useradd $AU
    id $AU || exit 1

    echo INFO: Installing Ansible as user $AU
    su -s /bin/bash -c "pip$PV install pipx" $AU
    su -s /bin/bash -c "~/.local/bin/pipx install --include-deps ansible" $AU

    echo INFO: Test Ansible as user $AU
    su -s /bin/bash -c "~/.local/bin/ansible --version" $AU

    if [ "$SA" == "Y" ]
    then
      echo INFO: Setup Ansible devel env in /etc/ansible
      ansibleconfigfile="/etc/ansible/ansible.cfg"
      test -d /etc/ansible || mkdir /etc/ansible ; chmod 755 /etc/ansible
      test -d /etc/ansible/projects || mkdir /etc/ansible/projects ; chmod 700 /etc/ansible/projects
      test -d /etc/ansible/playbooks || mkdir /etc/ansible/playbooks ; chmod 700 /etc/ansible/playbooks
      test -d /etc/ansible/collections || mkdir /etc/ansible/collections ; chmod 755 /etc/ansible/collections
      test -d /etc/ansible/roles || mkdir /etc/ansible/roles ; chmod 755 /etc/ansible/roles
      test -f $ansibleconfigfile && cp -anv $ansibleconfigfile $ansibleconfigfile.bak
      chown -R $AU:$AU /etc/ansible

      # Switch to user $AU
      sudo -iu $AU <<EOF

      . ~/.bashrc
      # Initialize ansible configuration
      ansibleconfigfile="/etc/ansible/ansible.cfg"
      ansible-config init --disabled -t all | sed -e 's|{{ ANSIBLE_HOME ~ "/|/etc/ansible/|g' -e 's|" }}||g' > \$ansibleconfigfile
      sed -i 's|^;inventory=|inventory=|' \$ansibleconfigfile
      sed -i 's|^;roles_path=.*|roles_path=roles_path=/etc/ansible/roles|' \$ansibleconfigfile
      sed -i 's|^;collections_path=.*|collections_path=/etc/ansible/collections|' \$ansibleconfigfile
      sed -i 's|^;nocows=.*|nocows=True|' \$ansibleconfigfile

      # Check if hosts file exists and configure localhost
      test -f /etc/ansible/hosts || echo "localhost ansible_connection=local ansible_become=False" > /etc/ansible/hosts
      # Test ansible shell module
      ansible -m shell -a id localhost
      echo "DONE, for testing role and collection overriding, run forex:

      ansible-galaxy collection install fortinet.fortios:2.3.6
      ansible-galaxy install joe-speedboat.os_update

      as user $AU"
EOF
    else
      echo SKIP: Setup Ansible devel env in /etc/ansible
    fi
    # Search galaxy for a collection
    su -s /bin/bash -c "~/.local/bin/ansible-galaxy search joe-speedboat | cat" $AU
  else
    echo INFO: User is not root, we setup as root
    exit 0
  fi
else
  echo "WARNING: No supported operating system found: os_type=$os_type os_ver=$os_ver"
fi
echo done
