# grab a static ip for the nat gateway to use
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# nat gateway in a public subnet so it can see internet
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  
  # public subnet id 
  subnet_id     = "subnet-04a8c56d32950f29b" 

  tags = {
    Name = "vet-hospital-nat"
  }
}

# tell the private subnets to send all their internet-bound traffic out through the nat
resource "aws_route" "private_nat_route" {
  
  # private route table id
  route_table_id         = "rtb-06220c841725735c6" 
  
  # this 0.0.0.0/0 block just means "literally anywhere on the internet"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

# link the second private subnet to join first one
resource "aws_route_table_association" "private_subnet_2_assoc" {
  
  # your floating 4005 subnet
  subnet_id      = "subnet-0e606c290592d4005"
  
  # paste that exact same route table ID here too!
  route_table_id = "rtb-06220c841725735c6"
}
