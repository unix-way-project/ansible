
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "nodes" {
    count = var.replica_set_count

    name = "${var.replica_set_name}-${count.index}"

    vpc_uuid = var.vpc_id
    image = "debian-10-x64"
    region = var.do_region
    size = var.replica_set_size
    private_networking = true
    ssh_keys = [
      var.ssh_key_id
    ]
}
