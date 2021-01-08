#!/bin/bash

set -e

NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'

TF_VER="0.13.5"
TF=$(which terraform)

prompt_yn () {
	while true; do
		read -p "$1. Enter y/n: " var
		if [ $var = "y" ]; then
			return 0
		elif [ $var = "n" ]; then
			return 1
		fi
	done
}

check_tf () {
	local tf=$($TF version)
	if [ $? -ne 0 ]; then
		tf=$(./download/terraform version)
		if [ $? -ne 0 ]; then
			return 1
		fi
		TF=./download/terraform
	fi
	return 0
}

setup_tf () {
	check_tf
	if [ $? -ne 0 ]; then
		echo -e "${RED}terrafrom not found.${NOCOLOR}"
		prompt_yn "Download terraform ${TF_VER} locally?"
		if [ $? -eq 0 ]; then
			echo "Downloading terraform v${TF_VER} to ./download"
			mkdir -p ./download
			pushd ./download
			wget "https://releases.hashicorp.com/terraform/${TF_VER}/terraform_${TF_VER}_linux_amd64.zip"
			unzip terraform_${TF_VER}_linux_amd64.zip
			rm terraform_${TF_VER}_linux_amd64.zip
			popd
			echo -e "${GREEN}terraform downloaded.${NOCOLOR}"
			TF=./download/terraform
		else
			echo -e "${RED}Please install terraform and rerun setup.${NOCOLOR}"
			echo "https://www.terraform.io/downloads.html"
			exit 1
		fi
	fi
	ls $HOME/.terraform.d/credentials.tfrc.json > /dev/null
	if [ $? -ne 0 ]; then
		echo "No terraform login detected, running terraform login."
		$($TF login)
	fi
}

setup_python () {
	echo "Checking for python3"
	localp3=$(python3 --version)
	if [ $? -ne 0 ]; then
		echo -e "${RED}python3 not found.${NOCOLOR}"
		exit 1
	fi
	echo -e "${GREEN}python3 found${NOCOLOR}"
	echo "Setting up virtual environment"
	local p3v=$(python3 -m venv venv)
	if [ $? -ne 0 ]; then
		echo -e "${RED}python3 venv setup failed.${NOCOLOR}"
		exit 1
	fi
}

setup_env () {
	read -p "Enter Digital Ocean Token (for deployment): " do_token
	echo "Checking Digital Ocean API credentials"
	curl --fail -XGET -H "Content-Type: application/json" -H "Authorization: Bearer ${do_token}" "https://api.digitalocean.com/v2/account" > /dev/null
	if [ $? -ne 0 ]; then
		echo -e "${RED}Unable to validate token with API.${NOCOLOR}"
		exit 1
	fi

	echo "Please generate a Steam GSLT using appid 730: https://steamcommunity.com/dev/managegameservers"
	read -p "Enter GSLT: " gslt
	read -p "Enter RCON password: " rcon
	read -p "Enter server password (blank for no password): " serverpass
	read "Enter the server name: " servername

	echo "export DIGITALOCEAN_TOKEN=\"${do_token}\""  > .env
	echo "export CSGO_GSLT=\"${gslt}\""              >> .env
	echo "export CSGO_RCONPASSWORD=\"${rcon}\""      >> .env
	echo "export CSGO_SV_PASSWORD=\"${serverpass}\"" >> .env
	echo "export CSGO_HOSTNAME=\"${servername}\""    >> .env
}

echo "Checking environment"

setup_python
setup_tf
setup_env

echo -e "${GREEN}Done!${NOCOLOR}"
echo "Environment file created run: source .env"
echo "Please change values in terraform/deployment/backend.tfvars and terraform/deployment/variables.tfvars before running terraform"
