# Tests

Installer scripts moved to:

<https://github.com/joe-speedboat/linux.scripts/tree/master/ansible>

## Local role-template syntax check

Run the test playbook from a harness directory with both the Galaxy role name and
repository basename symlinked. The dispatcher searches for
`roles/{{ role_path | basename }}/tasks`, which can resolve to `ansible.template`
when the checkout directory has that name.

```bash
rm -rf /tmp/hermes-ansible-template-harness
mkdir -p /tmp/hermes-ansible-template-harness/roles
ln -sfn "$PWD" /tmp/hermes-ansible-template-harness/roles/joe-speedboat.template
ln -sfn "$PWD" /tmp/hermes-ansible-template-harness/roles/ansible.template
cd /tmp/hermes-ansible-template-harness
ANSIBLE_ROLES_PATH=roles ansible-playbook /path/to/ansible.template/tests/test.yml -i localhost, -c local --syntax-check
```
