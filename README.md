# terraform-examples

This repository contains some terraform examples, which should show, why it is important to start with automation on day 0 and why it isn't a good idea to change options by hand.

## Global Setup

All examples were tested with terraform version v1.2.5.

Before using this examples set the following environment variables:

- `NSXT_MANAGER_HOST`(without HTTP/S)
- `NSXT_USERNAME`
- `NSXT_PASSWORD`
- `VSPHERE_SERVER` (without HTTP/S)
- `VSPHERE_USER`
- `VSPHERE_PASSWORD`

All examples were tested in our sandbox vcsasdbx01 / nsxsdbx01.