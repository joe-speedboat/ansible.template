# Bitbull Ansible Role Template

## Why

This repository is a reusable Ansible role template for roles that need clear,
dynamic OS-specific task dispatching while staying compatible with AWX.

The template is designed to make role maintenance easier by keeping task order
stable and selecting the best matching implementation from Ansible facts.

## How it works

The dispatcher in `tasks/main.yml`:

1. Sets `ansible_distribution_combine` to `rhelAll` for RHEL-like distributions
   (`AlmaLinux`, `Rocky`, `RedHat`) and to `dummy` for all other systems.
2. Finds all task files below `tasks/` whose filename matches
   `^[0-9]{2}_.*.yml$`.
3. Deduplicates task basenames and sorts them by filename.
4. Includes each basename once through `tasks/include-file.yml`.

For every task basename, `tasks/include-file.yml` uses the first existing file
from this order:

```text
tasks/{{ ansible_distribution }}-{{ ansible_distribution_version }}/<task>.yml
tasks/{{ ansible_distribution }}-{{ ansible_distribution_major_version }}/<task>.yml
tasks/{{ ansible_distribution }}/<task>.yml
tasks/{{ ansible_distribution_combine }}-{{ ansible_distribution_version }}/<task>.yml
tasks/{{ ansible_distribution_combine }}-{{ ansible_distribution_major_version }}/<task>.yml
tasks/{{ ansible_distribution_combine }}/<task>.yml
tasks/{{ ansible_os_family }}/<task>.yml
tasks/shared/<task>.yml
```

Examples:

- `tasks/Rocky-9/10_prep.yml` overrides `tasks/rhelAll/10_prep.yml` and
  `tasks/shared/10_prep.yml` on Rocky Linux 9 hosts.
- `tasks/rhelAll/20_setup.yml` can be used for common AlmaLinux, Rocky Linux,
  and Red Hat Enterprise Linux logic.
- `tasks/Ubuntu/20_setup.yml` can be used for Ubuntu-specific logic.
- `tasks/shared/30_post.yml` is the final fallback when no OS-specific file
  exists for the same basename.

## Example layout

```text
tasks/shared/01_run_on_all_systems.yml

tasks/Rocky-9/10_prep.yml
tasks/shared/10_prep.yml

tasks/Rocky-8/20_setup.yml
tasks/shared/20_setup.yml

tasks/Rocky-8/30_post.yml
tasks/shared/30_post.yml
```

Numeric prefixes define execution order. The same basename can exist in multiple
OS folders; only the first matching implementation is included for a host.

## Drawback

Conditional grouping still has to be implemented inside the selected task file
when several tasks need to be wrapped in the same `block`.

## Role skeleton

After copying this template for a real role, update at least:

- `meta/main.yml` (`role_name`, description, supported platforms)
- `defaults/main.yml` (user-overridable variables)
- `vars/main.yml` (fixed internal variables)
- `tasks/*` (replace the example debug tasks)
- `handlers/main.yml` (replace the example service handler)
- `tests/test.yml` (use the final Galaxy role name)

## Installation

```bash
ansible-galaxy install joe-speedboat.template
```

## Requirements

- Ansible 2.9 or higher
- A supported Linux distribution for the role generated from this template

## Role variables

Document user-overridable variables in `defaults/main.yml`. Keep fixed internal
maps and constants in `vars/main.yml`.

## Dependencies

This template has no role dependencies.

## License

GPL-3.0: <https://opensource.org/licenses/GPL-3.0>

Copyright (c) Chris Ruettimann <chris@bitbull.ch>

## Support

Many thanks to all Open Source supporters. If you use this construct for
productive work, please consider a donation to
[Stiftung Buehl](https://www.stiftung-buehl.ch/ueber-uns/spenden).
