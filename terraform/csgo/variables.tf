variable "region" {
  type        = string
  description = "Digital Ocean region"
}

variable "domain" {
  type        = string
  description = "The domain used to access the cs go server."
}

variable "server_size" {
  type        = string
  description = "Droplet size for cs go server"
  default     = "s-2vcpu-2gb"
}

variable "ssh_key_name" {
  type        = string
  description = "SSH key name"
}

variable "ssh_allowlist" {
  type        = list(string)
  description = "The CIDR blocks allowed to SSH onto droplets"
}
