resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "cyderes-vpc"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr_blocks[count.index]

  tags = {
    Name = "cyderes-public-subnet-${count.index + 1}"
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

output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}
