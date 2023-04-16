resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "cyderes-vpc"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)
  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnet_cidr_blocks[count.index]

  tags = {
    Name = "cyderes-private-subnet-${count.index + 1}"
  }
}

resource "aws_elasticsearch_domain" "this" {
  domain_name = "cyderes-es"

  elasticsearch_version = "7.9"
  cluster_config = {
    instance_type = var.elasticsearch_instance_type
  }

  vpc_options = {
    subnet_ids = aws_subnet.private.*.id
  }

  tags = {
    Name = "cyderes-es"
  }
}

output "endpoint" {
  value = aws_elasticsearch_domain.this.endpoint
}
