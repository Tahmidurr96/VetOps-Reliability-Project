# grab a static ip for the nat gateway to use
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# nat gateway in a public subnet so it can see the internet
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = "subnet-04a8c56d32950f29b"

  tags = {
    Name = "vet-hospital-nat"
  }
}

# dynamically fetch the vpc id so we don't have to hunt for it
data "aws_subnet" "selected" {
  id = "subnet-0e606c290592d4005"
}

# build a brand new, clean route table exclusively for our private subnets
resource "aws_route_table" "private_rt" {
  vpc_id = data.aws_subnet.selected.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "vet-private-route-table"
  }
}

# link the first private subnet to the new clean table
resource "aws_route_table_association" "private_subnet_1_assoc" {
  subnet_id      = "subnet-09ffb20c4da788637"
  route_table_id = aws_route_table.private_rt.id
}

# link the second private subnet to the new clean table
resource "aws_route_table_association" "private_subnet_2_assoc" {
  subnet_id      = "subnet-0e606c290592d4005"
  route_table_id = aws_route_table.private_rt.id
}

