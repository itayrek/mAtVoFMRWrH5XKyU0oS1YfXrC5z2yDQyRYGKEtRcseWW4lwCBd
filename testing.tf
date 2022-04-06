#Security Groups
resource "aws_security_group" "ec2-ssh-security-group" {
  name = "scenario-1-ssh-sg"
  vpc_id = "${aws_vpc.scenario-1-vpc.id}"
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"
    ]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [
          "0.0.0.0/0"
      ]
  }
}

resource "aws_security_group" "ec2-http-security-group" {
    name = "scenario-1-http-sg"
    vpc_id = "${aws_vpc.scenario-1-vpc.id}"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [
          "0.0.0.0/0"
      ]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
    }
  }

  resource "aws_vpc" "scenario-1-vpc" {
    cidr_block = "10.10.0.0/16"
    enable_dns_hostnames = true
  }
  #Internet Gateway
  resource "aws_internet_gateway" "scenario-1-internet-gateway" {
    vpc_id = "${aws_vpc.scenario-1-vpc.id}"
  }
  #Public Subnets
  resource "aws_subnet" "scenario-1-public-subnet-1" {
    availability_zone = "${var.aws_region}a"
    cidr_block = "10.10.10.0/24"
    vpc_id = "${aws_vpc.scenario-1-vpc.id}"
  }
  resource "aws_subnet" "scenario-1-public-subnet-2" {
    availability_zone = "${var.aws_region}b"
    cidr_block = "10.10.20.0/24"
    vpc_id = "${aws_vpc.scenario-1-vpc.id}"
  }
  #Public Subnet Routing Table
  resource "aws_route_table" "scenario-1-public-subnet-route-table" {
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.scenario-1-internet-gateway.id}"
    }
    vpc_id = "${aws_vpc.scenario-1-vpc.id}"
  }
  #Public Subnets Routing Associations
  resource "aws_route_table_association" "public-subnet-1-route-association" {
    subnet_id = "${aws_subnet.scenario-1-public-subnet-1.id}"
    route_table_id = "${aws_route_table.scenario-1-public-subnet-route-table.id}"
  }
  resource "aws_route_table_association" "public-subnet-2-route-association" {
    subnet_id = "${aws_subnet.scenario-1-public-subnet-2.id}"
    route_table_id = "${aws_route_table.scenario-1-public-subnet-route-table.id}"
  }
