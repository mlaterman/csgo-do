output "server_ip" {
  value = digitalocean_droplet.csgo.ipv4_address
}

output "domain" {
  value = var.domain
}
