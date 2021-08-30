
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "load_balancer" {
    count = var.load_balancer_count

    name = "${var.load_balancer_name}-${count.index}"

    vpc_uuid = var.vpc_id
    image = "debian-10-x64"
    region = var.do_region
    size = var.load_balancer_size
    private_networking = true
    ssh_keys = [
      var.ssh_key_id
    ]
}
