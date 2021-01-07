resource "digitalocean_droplet" "csgo" {
  image      = "ubuntu-20-04-x64"
  name       = "csgo"
  region     = var.region
  size       = var.server_size
  ssh_keys   = [data.digitalocean_ssh_key.ssh.id]
  backups    = false
  monitoring = false
}

resource "digitalocean_domain" "csgo" {
  name       = var.domain
  ip_address = digitalocean_droplet.csgo.ipv4_address
}

resource "digitalocean_firewall" "csgo" {
  name        = "ssh-and-steam"
  droplet_ids = [digitalocean_droplet.csgo.id]

  # SSH
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.ssh_allowlist
  }

  # DNS
  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Download steam apps
  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "udp"
    port_range = "27015-27030"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "tcp"
    port_range = "27015-27030"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # game server ports
  outbound_rule {
    protocol = "udp"
    port_range = "27005"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol = "udp"
    port_range = "27015"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol = "udp"
    port_range = "27020"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }


  inbound_rule {
    protocol = "tcp"
    port_range = "27015"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # p2p & voice chat
  inbound_rule {
    protocol = "udp"
    port_range = "3478"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol = "udp"
    port_range = "4379-4380"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "udp"
    port_range = "3478"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "udp"
    port_range = "4379-4380"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

}
