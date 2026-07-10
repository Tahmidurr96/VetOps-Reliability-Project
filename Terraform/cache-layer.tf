# cache-layer.tf to hold cache infrastructure

#===================
# ElastiCache Serverless
#====================

resource "aws_elasticache_serverless_cache" "example" {
  engine = "redis"
  name   = "vet-hospital-cache"

  security_group_ids       = [aws_security_group.redis_sg.id]
  subnet_ids               = "subnet-09ffb20c4da788637"
}