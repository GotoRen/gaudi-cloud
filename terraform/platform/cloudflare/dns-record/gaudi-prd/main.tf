/*************************************************
  Subdomain: gaudi.ren510.dev
  Record Type: NS
 *************************************************/
resource "cloudflare_record" "gaudi_ns" {
  for_each = toset(data.terraform_remote_state.cloud-dns.outputs.gaudi_ren510_dev_name_servers)

  zone_id = var.cloudflare_zone_id                                                  # Cloudflare Zone ID
  name    = data.terraform_remote_state.cloud-dns.outputs.gaudi_ren510_dev_dns_name # Subdomain ( gaudi.ren510.dev )
  content = each.value                                                              # Name Server lists
  type    = "NS"                                                                    # NS Record
  ttl     = 1                                                                       # TTL Automatic
  proxied = false                                                                   # DNS Only
}
