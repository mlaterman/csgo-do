default: plan

configure:
	cd terraform/csgo; terraform init -backend-config=../deployment/backend.tfvars

plan: configure
	cd terraform/csgo; terraform plan -var-file=../deployment/variables.tfvars -out=terraform.plan

apply:
	cd terraform/csgo; terraform apply terraform.plan

destroy:
	cd terraform/csgo; terraform destroy -var-file=../deployment/variables.tfvars

pip:
	pip3 install -r requirements.txt

hosts:
	bash genhosts.sh

ansible: hosts
	ansible-playbook -i hosts --extra-vars "lgsm_csgo_hostname=\"${CSGO_HOSTNAME}\"" --extra-vars "lgsm_csgo_gslt=${CSGO_GSLT}" --extra-vars "lgsm_csgo_rconpassword=${CSGO_RCONPASSWORD}" --extra-vars "lgsm_csgo_sv_password=${CSGO_SV_PASSWORD}" --extra-vars "lgsm_csgo_sourcemod_root_admin=\"${ROOT_ADMIN_ID}\"" --extra-vars "lgsm_csgo_sourcemod_admins=\"${ADMIN_LIST}\"" lgsm-csgo.yml

.PHONY: default configure plan apply pip hosts ansible
