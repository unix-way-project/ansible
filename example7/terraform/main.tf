
# https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs

# List all images: curl -X GET --silent "https://api.digitalocean.com/v2/images?per_page=999" -H "Authorization: Bearer $DO_API_TOKEN"
# List all sizes: curl -X GET --silent "https://api.digitalocean.com/v2/sizes?per_page=999" -H "Authorization: Bearer $DO_API_TOKEN"

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "unixway_keypair" {
  name = var.do_ssh_key
}

resource "digitalocean_vpc" "unixway_vpc" {
  name     = "unixway-vpc"
  region   = var.do_region
  ip_range = "10.0.0.0/24"
}

module "unixway_mongodb" {
  source = "./mongodb"

  do_region = var.do_region
  vpc_id = digitalocean_vpc.unixway_vpc.id
  ssh_key_id = data.digitalocean_ssh_key.unixway_keypair.id

  cluster_name = "uw-m1"
  replica_set_cfg_count = 3
  replica_set_cfg_size = "s-1vcpu-1gb"

  replica_sets_data_total = 2
  replica_set_data_size = "s-1vcpu-1gb"
  replica_set_data_count = 3
}

module "unixway_load_balancer" {
  source = "./lb"

  do_region = var.do_region
  vpc_id = digitalocean_vpc.unixway_vpc.id
  ssh_key_id = data.digitalocean_ssh_key.unixway_keypair.id

  load_balancer_name = "uw-m1-lb"
  load_balancer_size = "s-1vcpu-1gb"
  load_balancer_count = 1
}

resource "local_file" "inventory_file" {
  content = templatefile("${path.module}/templates/inventory.tpl",
    {
      unixway_mongodb = module.unixway_mongodb
      unixway_load_balancer = module.unixway_load_balancer
    }
  )
  filename = "./inventory.ini"
}
