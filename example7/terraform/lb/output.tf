
output "nodes" {
  value = [
    for node in digitalocean_droplet.load_balancer : {
        name = node.name,
        ip_public = node.ipv4_address,
        ip_private = node.ipv4_address_private
    }
  ]
}
