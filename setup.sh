#!/bin/bash

# Variables
role_name=uniqconsulting.graylog
role_github_name=ansible.graylog
role_displayname="Graylog Server"

# Check if installer has yet been run
if [ -f "/etc/ansible/projects/uqcSetup/.INSTALLED" ]; then
    dialog --title "Setup - Aborted" --msgbox "
    The setup has already been executed." 8 30
    clear

    exit 1
fi

# Setup dialog
yum install -y -q dialog > /dev/null

# Base Setup
curl -s https://raw.githubusercontent.com/uniQconsulting-ag/$role_github_name/master/setup_1.sh > /tmp/setup_1.sh
chmod +x /tmp/setup_1.sh
/tmp/setup_1.sh  2>&1  | dialog --title "Setup - Ansible Project" --progressbox $(expr $(tput lines) - 5) $(expr $(tput cols) - 5)
clear

# Show Dialog
dialog --title "Setup - Edit Config" --editbox /etc/ansible/projects/uqcSetup/vars/99_$role_name.yml $(expr $(tput lines) - 5) $(expr $(tput cols) - 5) 2> /tmp/99_$role_name.yml
clear
cp /tmp/99_$role_name.yml /etc/ansible/projects/uqcSetup/vars/99_$role_name.yml > /dev/null

# Running ansible
cd /etc/ansible/projects/uqcSetup
ansible-playbook install_1_appliance.yml 2>&1 | tee /tmp/playbook.log | dialog --title "Setup - Running Playbook" --progressbox $(expr $(tput lines) - 5) $(expr $(tput cols) - 5)
rm -f /tmp/setup_1.sh > /dev/null
clear

# Show Output
dialog --title "Setup - Running Playbook" --textbox /tmp/playbook.log $(expr $(tput lines) - 5) $(expr $(tput cols) - 5)
clear

# Create "trigger" file
touch /etc/ansible/projects/uqcSetup/.INSTALLED

# Cleanup
rm -f /tmp/playbook.log
rm -f /tmp/99_$role_name.yml

# Done
dialog --title "Setup - Done" --msgbox "
We are all done. Thank you for installing $role_displayname." 8 30
clear