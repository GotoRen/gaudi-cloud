resource "aws_vpc" "vpc" {
  cidr_block                       = var.vpc_cidr # VPC に設定したい CIDR を指定
  instance_tenancy                 = "default"    # VPC 内インスタンスのテナント属性を指定
  enable_dns_support               = true         # VPC 内で DNS による名前解決を有効化するかを指定
  enable_dns_hostnames             = true         # VPC 内インスタンスが DNS ホスト名を取得するかを指定
  assign_generated_ipv6_cidr_block = false        # IPv6 を有効化するかを指定

  tags = merge(
    {
      Name = var.vpc_name
    },
    var.tags
  )
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = var.vpc_name
    },
    var.tags
  )
}

resource "aws_route" "default" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_vpc.vpc.default_route_table_id
  gateway_id             = aws_internet_gateway.gw.id
}
