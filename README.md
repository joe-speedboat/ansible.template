# BITBULL ANSIBLE ROLE TEMPLATE

## WHY
When Red Hat officially started supporting Ansible, I had a lot of fun immersing myself    
in this really new concept of automation and keeping my knowledge up to date.   

A must for every efficient Linux consultant!   

Just like with the GitHub repos, which at the beginning are the desired solution to a problem,    
with their excessive use it quickly becomes clear that management and maintenance are the    
factors that determine the expense of these resources in the future.   

I have always been of the opinion that what cannot be maintained in Operations has been developed incorrectly.     
And I am constantly trying to do justice to this.    

For this purpose I have developed an Ansible role template, which is mandatory:    
* Clear
* Unambiguous
* Dynamic
which in turn reduces:    
* Error
* Familiarization
* Maintenance

This template concept, which I searched on the internet and did not find is foremost compatible with the current version of AWX.    
(upstream project for Ansible Tower)



# <ROLENAME>

Installation with ansible-galaxy:

``` bash
ansible-galaxy install joe-speedboat.template
```

## Requirements xxx

* Currently tested with CentOS 7 and CentOS 8
* Ansible 2.9 or higher is required for this Ansible Role

* Operating System: CentOS8 || CentOS7
* OS Disk: min 00 GB
* Data Disk: min 00 GB
* CPU: min 00   
* Memory: min 00 GB   



Role Variables
--------------

Variables are speaking or documented in defaults/main.yml   
One variable is mandatory: var1xxx


## Dependencies

This Ansilbe Role has no dependencies to other Ansilbe Roles

License
-------
https://opensource.org/licenses/GPL-3.0    
Copyright (c) Chris Ruettimann <chris@bitbull.ch>
