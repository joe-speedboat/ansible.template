# BITBULL ANSIBLE ROLE TEMPLATE

## WHY
When Red Hat officially started supporting Ansible, I had a lot of fun immersing myself    
in this really new concept of automation and keeping my knowledge up to date.   

A must for every efficient Linux consultant!   

Just like GitHub repos, which at the beginning was the desired solution to a long worn problem,    
with its excessive use it quickly became clear that management and maintenance are the    
factors that determine the expense of these resources you have to spend in the future.   

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

## HOW IT WORKS
* Create a deduplicated list of task files
* Reorder them by numbers
* Run tasks by first match with the ansible_facts of the target machine (```include-file.yml```)
  * ```{{  ansible_distribution_custom }}-{{ ansible_distribution_version }}```
    * rhelClone-7.9
  * ```{{ ansible_distribution_custom }}-{{ ansible_distribution_major_version }}```
    * rhelClone-7
  * ```{{ ansible_distribution_custom }}```
    * rhelClone
  * ```{{ ansible_distribution }}-{{ ansible_distribution_version }}```
    * CentOS-7.9
    * Ubuntu-20.04
  * ```{{ ansible_distribution }}-{{ ansible_distribution_major_version }}```
    * CentOS-7
    * Ubuntu-20
  * ```{{ ansible_distribution }}```
    * CentOS
    * Ubuntu
  * ```{{ ansible_os_family }}```
    * RedHat
    * Debian
  * ```shared```
    * This is the fallback, if noting above matches

* Note, since RockyLinux and AlmaLinux are RHEL clones that work almost similar, we needed just one os folder for both
  * If you need tasks that work for Alma and Rocky, create a folder named ```rhelClone``` in ```tasks``` folder
    * It get catched like the var ```{{ ansible_distribution }}``` above

You can look ito the role directory, it will be clear why and how to use it.   

To get an overview, just look up the file names:
```
$ find tasks -type f -name '*.yml' #modified view

tasks/shared/01_run_on_all_systems.yml

tasks/CentOS-7/10_prep.yml
tasks/shared/10_prep.yml

tasks/CentOS-8/20_setup.yml
tasks/shared/20_setup.yml

tasks/CentOS-8/30_post.yml
tasks/shared/30_post.yml
```

## Drawback of this solution
Including of task-files, depending on given ansible-facts, has to get created in blocks statements within the task files itself.

## One final word
Many thanks to all supporters of OpenSource products,    
only by sharing our solutions we could get this far!   
If you use this construct for your productive work,    
we would appreciate a donation to the [Stifung Buehl](https://www.stiftung-buehl.ch/ueber-uns/spenden).   
All our know-how is OpenSource and your donation enables    
children and young people with special needs to find a place in life.   

Chris Ruettimann <chris@bitbull.ch>

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

