/******************************************
	Public configuration
 *****************************************/
resource "aws_route_table" "public" {
  count = length(aws_subnet.public)

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = "${var.public_subnets[count.index].name}-route"
    },
    var.public_subnets[count.index].tags
  )

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route" "public" {
  count = length(aws_route_table.public)

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public[count.index].id
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

/******************************************
	Private configuration
 *****************************************/
resource "aws_route_table" "private" {
  count = length(aws_subnet.private)

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = "${var.private_subnets[count.index].name}-route"
    },
    var.private_subnets[count.index].tags
  )

  depends_on = [aws_nat_gateway.default] # NAT Gateway を依存リソースとする
}

# プライベートネットワークのルーティング条件を追加: Private Subnet -> NAT Gateway -> Internet Gateway
resource "aws_route" "private_routing_via_nat" {
  count = length(aws_subnet.private)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.default[0].id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id

  depends_on = [aws_route.private_routing_via_nat]
}

/******************************************
	Public nat configuration
 *****************************************/
resource "aws_eip" "nat" {
  count  = length(aws_subnet.public_nat)
  domain = "vpc"

  tags = merge(
    {
      Name = "${var.public_nat_subnets[count.index].name}-nat-eip"
    },
    var.public_nat_subnets[count.index].tags
  )

  depends_on = [aws_internet_gateway.gw, aws_subnet.public_nat]
}

resource "aws_nat_gateway" "default" {
  count = length(aws_subnet.public_nat)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public_nat[count.index].id

  tags = merge(
    {
      Name = "${var.public_nat_subnets[count.index].name}-nat"
    },
    var.public_nat_subnets[count.index].tags
  )

  depends_on = [aws_eip.nat]
}

resource "aws_route_table_association" "nat" {
  count = length(aws_subnet.public_nat)

  subnet_id      = aws_subnet.public_nat[count.index].id
  route_table_id = aws_vpc.vpc.default_route_table_id

  depends_on = [aws_subnet.public_nat]
}
