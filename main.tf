provider "aws" {
    region = "ap-northeast-1"
}

# 1. vpc
resource "aws_vpc" "internship-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
      Name = "osc-vpc"
  }
}

# 2. subnet
resource "aws_subnet" "internship-subnet-1" {
  vpc_id = aws_vpc.internship-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
      Name = "osc-subnet-1"
  }
}

resource "aws_subnet" "internship-subnet-2" {
  vpc_id = aws_vpc.internship-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
      Name = "osc-subnet-2"
  }
}

# 3. Internet Gateway
resource "aws_internet_gateway" "internship-gw" {
  vpc_id = aws_vpc.internship-vpc.id
  tags = {
      Name = "osc-gw"
  }
}

# 4. Route table
# Destination : 10.0.0.0/16, Target : local은 자동으로 설정된다
# default Route table까지 총 2개 생성된다
resource "aws_route_table" "internship-rt" {
  vpc_id = aws_vpc.internship-vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.internship-gw.id
  }
  tags = {
      Name = "osc-rt"
  }
}

# 5. Security Group
# default Security Group까지 총 5개 생성된다
resource "aws_security_group" "internship-sg-1" {
  name        = "allow_80"
  description = "Allow inbound traffic when port number is 80"
  vpc_id = aws_vpc.internship-vpc.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.internship-vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "osc-sg-1"
  }
}

resource "aws_security_group" "internship-sg-2" {
  name        = "allow_from-internship-sg-1"
  description = "Allow inbound traffic when traffic is from resource with internship-sg-1"
  vpc_id = aws_vpc.internship-vpc.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups = [aws_security_group.internship-sg-1.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "osc-sg-2"
  }
}


resource "aws_security_group" "internship-sg-3" {
  name        = "allow_80_8080"
  description = "Allow inbound traffic when port number is 80 or 8080"
  vpc_id = aws_vpc.internship-vpc.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.internship-vpc.cidr_block]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.internship-vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "osc-sg-3"
  }
}

resource "aws_security_group" "internship-sg-4" {
  name        = "allow_from-internship-sg-3"
  description = "Allow inbound traffic when traffic is from resource with internship-sg-3"
  vpc_id = aws_vpc.internship-vpc.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups = [aws_security_group.internship-sg-3.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "osc-sg-4"
  }
}
