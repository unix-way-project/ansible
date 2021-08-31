
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

module "rs_cfg" {
  source = "./replicaset"

  do_region = var.do_region
  vpc_id = var.vpc_id
  ssh_key_id = var.ssh_key_id

  replica_set_name = "${var.cluster_name}-cfg"
  replica_set_size = var.replica_set_cfg_size
  replica_set_count = var.replica_set_cfg_count
}

module "rs_data" {
  for_each = toset(formatlist("rs%d", range(var.replica_sets_data_total)))

  source = "./replicaset"

  do_region = var.do_region
  vpc_id = var.vpc_id
  ssh_key_id = var.ssh_key_id

  replica_set_name = "${var.cluster_name}-${each.key}"
  replica_set_size = var.replica_set_data_size
  replica_set_count = var.replica_set_data_count
}
