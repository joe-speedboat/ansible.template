# Tests

This template must be tested like an installed role. The dispatcher searches for
`roles/{{ role_path | basename }}/tasks`, so direct execution from the checkout
can fail even when the role itself is valid.

## Local harness

Create a temporary harness with both common role names symlinked:

```bash
rm -rf /tmp/hermes-ansible-template-harness
mkdir -p /tmp/hermes-ansible-template-harness/roles
ln -sfn /path/to/ansible.template /tmp/hermes-ansible-template-harness/roles/joe-speedboat.template
ln -sfn /path/to/ansible.template /tmp/hermes-ansible-template-harness/roles/ansible.template
cd /tmp/hermes-ansible-template-harness
```

Run syntax and smoke tests:

```bash
ANSIBLE_ROLES_PATH=roles ansible-playbook /path/to/ansible.template/tests/test.yml -i localhost, -c local --syntax-check
ANSIBLE_ROLES_PATH=roles ansible-playbook /path/to/ansible.template/tests/test.yml -i localhost, -c local
```

Expected smoke-test result for the unmodified template:

```text
failed=0
```

Warnings about missing AWX/system role paths are acceptable in this local
harness as long as the symlinked role path is found and the play finishes with
`failed=0`.

## When creating a real role

After copying the template:

1. Replace `joe-speedboat.template` in `tests/test.yml` with the final role name.
2. Update the symlink names above to match the new role and repository basename.
3. Add real host tests for the supported OS matrix.
4. Run idempotency checks; the second run should report no unexpected changes.
5. Verify effects independently, not only by Ansible recap.
