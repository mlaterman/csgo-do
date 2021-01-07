resource "digitalocean_project" "csgo" {
  name        = "csgo-${var.domain}"
  description = "A project to host CS:GO"
  purpose     = "Web Application"
  resources   = [
    digitalocean_droplet.csgo.urn,
    digitalocean_domain.csgo.urn
  ]
}
