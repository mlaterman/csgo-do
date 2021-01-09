# csgo-do

Project used to deploy an configure Counter Strike Global offensive on a Digital Ocean droplet using LGSM.

## Requirements

* Digital ocean account with an SSH key and access token.
* Steam [Game Server Login Token](http://steamcommunity.com/dev/managegameservers) (GSLT).
* python3/pip3
* terraform 0.13.5+ and terraform cloud

## Setup

1. Run `./setup.sh` to ensure terraform is installed/logged in and to create an environment file.
1. Run `source .env` to use the environment file.
1. Activate the python virtual environment by running `source venv/bin/activate`.
1. Change values in `terraform/deployment/backend.tfvars` to reflect your (terraform cloud) org and workspace, and `terraform/deployment/variables.tfvars` as needed (domain, SSH allowlist, etc.).
1. Plan the terraform changes by running `make plan`, this shows the changes that will occur on Digital Ocean.
1. Apply the terrafrom changes by running `make apply`, this creates the resources on Digital Ocean.
1. Install python requirements by running `make pip`
1. Install/configure CS:GO on the droplet by running `make ansible`

## Environment Variables

| variable | description |
|----------|-------------|
| DIGITALOCEAN_TOKEN | DO token used by terraform |
| CSGO_GSLT | Steam's Game Server Login Token inserted by Ansible |
| CSGO_RCONPASSWORD | CS:GO's remote console password |
| CSGO_SV_PASSWORD | CS:GO's server password, set to empty for a public server |
| CSGO_HOSTNAME | CS:GO server hostname (in the server browser) |
| ROOT_ADMIN_ID| steamID of the user who will get root admin permissions in SourceMod in the server |
| ADMIN_LIST | comma seperated values list of steamIDs for additional admins |

## Why GSLT instead of steamCMD

GSLT has some quality of life features when it comes to managing a server.

