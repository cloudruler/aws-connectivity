data "aws_region" "current" {}

resource "aws_vpc_ipam" "ipam" {
  operating_regions {
    region_name = data.aws_region.current.name
  }
}

resource "aws_vpc_ipam_pool" "ipam_pool" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.ipam.private_default_scope_id
  locale         = data.aws_region.current.name
}

resource "aws_vpc_ipam_pool_cidr" "pool_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.ipam_pool.id
  cidr         = "10.1.0.0/24" #10.1.0.0 - 10.1.0.255 (255 ips)
}

resource "aws_vpc" "vpc" {
  ipv4_ipam_pool_id   = aws_vpc_ipam_pool.ipam_pool.id
  ipv4_netmask_length = 24
  depends_on = [
    aws_vpc_ipam_pool_cidr.pool_cidr
  ]
}