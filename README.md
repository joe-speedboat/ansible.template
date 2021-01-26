# Template Guide

There are some differences, if this is a wrapper-role for an appliance, or if it is a standalone role.

## Appliance

* Add your variables to `defaults` and `vars`, but keep the variables already in there. (You can change the value if needed.)
* Add your `files` & `templates` to the folders
* Update your `handlers`, you can delete the ones in there. Those are just examples
* Update the `meta` file. The minimum required are `role_name` and `description`
* Create your tasks files in a subfolder of `tasks`. Don't use the root-folder. (Add them in the format 00_name.yml - gets sorted by name/number)
* Update the `shared/pre_dependencies.yml`, but keep the 3 default includes in there.
* Update the `shared/post_dependencies.yml`, you can delete the ones in there. There just as an example.
* Update the variables in `setup.sh` and `setup_1.sh`. Graylog was used as an example, to make it more clear.
* Rename `tests/vars/99_uniqconsulting.ROLENAME.yml` and add all needed variables with examples
* Rename `tests/install_X_rolename.yml` and add the correct role inside
* Remove `files/README.md` and `templates/README.md`
* Remove or Update + Rename `tests/uQcCheck_rolename.yml`
* Update or remove `motd.md`
* Replace this file with `README_TEMPLATE.md` and edit it as needed

## Standalone

* Add your variables to `defaults` and `vars`. You can delete the ones in there, except `role_include_files`.
* Add your `files` & `templates` to the folders
* Update your `handlers`, you can delete the ones in there. Those are just examples.
* Update the `meta` file. The minimum required are `role_name` and `description`
* Delete the files in `tasks/shared`, and update the `tasks/main.yml` to not include these anymore
* Create your tasks files in a subfolder of `tasks`. Don't use the root-folder. (Add them in the format 00_name.yml - gets sorted by name/number)
* Rename `tests/vars/99_uniqconsulting.ROLENAME.yml` and add all needed variables with examples
* Rename `tests/install_X_rolename.yml` and add the correct role inside
* Remove `files/README.md`, `templates/README.md`, `setup_1.sh` and `setup.sh`
* Remove or Update + Rename `tests/uQcCheck_rolename.yml`
* Update or remove `motd.md`
* Replace this file with `README_TEMPLATE.md` and edit it as needed
