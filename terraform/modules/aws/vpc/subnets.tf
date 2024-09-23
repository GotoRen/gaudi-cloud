/******************************************
	Public configuration
 *****************************************/
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.public_subnets[count.index].availability_zone
  cidr_block        = var.public_subnets[count.index].cidr_block

  assign_ipv6_address_on_creation = false
  map_public_ip_on_launch         = true

  tags = merge(
    {
      Name = var.public_subnets[count.index].name
    },
    var.public_subnets[count.index].tags
  )

  depends_on = [aws_internet_gateway.gw]
}

/******************************************
	Private configuration
 *****************************************/
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.private_subnets[count.index].availability_zone
  cidr_block        = var.private_subnets[count.index].cidr_block

  assign_ipv6_address_on_creation = false
  map_public_ip_on_launch         = false

  tags = merge(
    {
      Name = var.private_subnets[count.index].name
    },
    var.private_subnets[count.index].tags
  )

  depends_on = [aws_internet_gateway.gw]
}

/******************************************
	Public nat configuration
 *****************************************/
resource "aws_subnet" "public_nat" {
  count = length(var.public_nat_subnets)

  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.public_nat_subnets[count.index].availability_zone
  cidr_block        = var.public_nat_subnets[count.index].cidr_block

  assign_ipv6_address_on_creation = false
  map_public_ip_on_launch         = true

  tags = merge(
    {
      Name = var.public_nat_subnets[count.index].name
    },
    var.public_nat_subnets[count.index].tags
  )

  depends_on = [aws_internet_gateway.gw]
}
