data "aws_region" "current" {}

resource "aws_vpc_ipam" "ipam" {
  operating_regions {
    region_name = "us-west-1"
  }
}

moved {
  from = aws_vpc_ipam_pool.ipam_pool
  to = aws_vpc_ipam_pool.aws_ipam_pool
}

resource "aws_vpc_ipam_pool" "aws_ipam_pool" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.ipam.private_default_scope_id
  locale         = data.aws_region.current.name
}

# resource "aws_vpc_ipam_pool" "_ipam_pool" {
#   address_family = "ipv4"
#   ipam_scope_id  = aws_vpc_ipam.ipam.private_default_scope_id
#   locale         = data.aws_region.current.name
# }

# resource "aws_vpc_ipam_pool_cidr" "pool_cidr" {
#   ipam_pool_id = aws_ipam_pool.ipam_pool.id
#   cidr         = var.hub_cidr
# }

# resource "aws_vpc" "vpc" {
#   ipv4_ipam_pool_id   = aws_ipam_pool.ipam_pool.id
#   ipv4_netmask_length = var.vpc_netmask_length
#   depends_on = [
#     aws_vpc_ipam_pool_cidr.pool_cidr
#   ]
# }
