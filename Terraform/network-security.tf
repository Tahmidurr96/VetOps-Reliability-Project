#===========================
# A SECURITY GROUP FOR THE LAMBDA FUNCTION
#==========================================

resource "aws_security_group" "lambda_sg" {
    name = "vet-cache-lambda-sg"
    vpc_id = "vpc-080dbb0b7dc86503a"
  

# egress rule to allow lambda to talk to elasticache
  egress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }
# egress rule to let lambda to fetch data from the backend (if it isnt cached)
egress {
    from_port = 80
    to_port = 443
    protocol = "tcp"
    cidr_blocks = "0.0.0.0/0"
}
}

#==========================================
# A SECURITY GROUP FOR THE ELASTICACHE
#==========================================

resource "aws_security_group" "elasticache_sg" {
    name = "vet-cache-redis-sg"
    vpc_id = "vpc-080dbb0b7dc86503a"

ingress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    # this line allows only our lambda to connect to this cache
    security_groups = [aws_security_group.lambda_sg.id]
}

}