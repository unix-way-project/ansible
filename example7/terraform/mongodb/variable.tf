
variable "do_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ssh_key_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "replica_set_cfg_size" {
  type = string
}

variable "replica_set_cfg_count" {
  type = number
}

variable "replica_sets_data_total" {
  type = number
}

variable "replica_set_data_size" {
  type = string
}

variable "replica_set_data_count" {
  type = number
}
