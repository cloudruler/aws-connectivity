data "aws_region" "current" {}

resource "aws_vpc_ipam" "ipam" {
  operating_regions {
    region_name = "us-west-1"
  }
  operating_regions {
    region_name = "us-west-2"
  }
}

resource "aws_vpc_ipam_pool" "aws_ipam_pool" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.ipam.private_default_scope_id
}

resource "aws_vpc_ipam_pool_cidr" "aws_pool_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.aws_ipam_pool.id
  cidr         = var.aws_cidr
}

resource "aws_vpc_ipam_pool" "region_ipam_pool" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.ipam.private_default_scope_id
  source_ipam_pool_id = aws_vpc_ipam_pool.aws_ipam_pool.id
  locale = data.aws_region.current.name
}

resource "aws_vpc_ipam_pool_cidr" "region_pool_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.region_ipam_pool.id
  cidr         = var.region_cidr
}

resource "aws_vpc_ipam_pool" "region_nonprod_ipam_pool" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.ipam.private_default_scope_id
  source_ipam_pool_id = aws_vpc_ipam_pool.region_ipam_pool.id
  locale = data.aws_region.current.name
  description = "${data.aws_region.current.name} non-prod"
  tags = {
    "environment" = "nonprod"
  }
}

resource "aws_vpc_ipam_pool_cidr" "region_nonprod_pool_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.region_nonprod_ipam_pool.id
  cidr         = var.region_nonprod_cidr
}

resource "aws_vpc_ipam_pool" "region_prod_ipam_pool" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.ipam.private_default_scope_id
  source_ipam_pool_id = aws_vpc_ipam_pool.region_ipam_pool.id
  locale = data.aws_region.current.name
  description = "${data.aws_region.current.name} prod"
  tags = {
    "environment" = "prod"
  }
}

resource "aws_vpc_ipam_pool_cidr" "region_prod_pool_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.region_prod_ipam_pool.id
  cidr         = var.region_prod_cidr
}


# resource "aws_vpc" "vpc" {
#   ipv4_ipam_pool_id   = aws_vpc_ipam_pool.aws_ipam_pool.id
#   ipv4_netmask_length = var.vpc_netmask_length
#   depends_on = [
#     aws_vpc_ipam_pool_cidr.pool_cidr
#   ]
# }
