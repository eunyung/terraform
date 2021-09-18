provider "aws" {
  region = "ap-northeast-2"
}

/*
 * ----------VPC Settings----------
 */

resource "aws_vpc" "aws-vpc" {
  cidr_block           = var.aws_network_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "aws-vpc"
  }
}

resource "aws_subnet" "aws-subnet1" {
  vpc_id     = aws_vpc.aws-vpc.id
  cidr_block = var.aws_subnet1_cidr
  

  tags = {
    Name = "aws-vpn-subnet"
  }
}

resource "aws_internet_gateway" "aws-vpc-igw" {
  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name = "aws-vpc-igw"
  }
}

resource "aws_route_table" "kubernetes" {
   vpc_id = aws_vpc.aws-vpc.id

   # Default route through Internet Gateway
   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.aws-vpc-igw.id
   }

  tags = { 
      Name = "aws-route-table"
  }
}

resource "aws_route_table_association" "kubernetes" {
  subnet_id      = aws_subnet.aws-subnet1.id
  route_table_id = aws_route_table.kubernetes.id
}

/*
 * ----------Security Settings----------
 */


# Allow PING testing.
resource "aws_security_group" "aws-allow-icmp" {
  name        = "aws-allow-icmp"
  description = "Allow icmp access from anywhere"
  vpc_id      = aws_vpc.aws-vpc.id

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allow SSH for iperf testing.
resource "aws_security_group" "aws-allow-ssh" {
  name        = "aws-allow-ssh"
  description = "Allow ssh access from anywhere"
  vpc_id      = aws_vpc.aws-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allow TCP traffic from the Internet.
resource "aws_security_group" "aws-allow-internet" {
  name        = "aws-allow-internet"
  description = "Allow http traffic from the internet"
  vpc_id      = aws_vpc.aws-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


/*
 * ----------bootstrap vm Settings----------
 */


resource "aws_instance" "bootstrap" {
  count         = 1
  ami           = var.amis
  instance_type = var.aws_instance_type
  subnet_id     = aws_subnet.aws-subnet1.id
  key_name      = "test4"  #이미 aws 콘솔에서 만든 key_pair의 이름
  associate_public_ip_address = true
  private_ip                  = "172.16.0.10"
  availability_zone = var.zone
  vpc_security_group_ids = [
    aws_security_group.aws-allow-icmp.id,
    aws_security_group.aws-allow-ssh.id,
    aws_security_group.aws-allow-internet.id,
  ]
  
  user_data = <<-EOT
	#! /bin/bash
	sudo -i
	sed -i '$a\172.16.0.20 master1 172.16.0.21 master2 172.0.16.30 worker1 172.0.16.31 worker2 172.16.0.32 worker3' /etc/hosts
	yum repolist
	echo 1 > /proc/sys/net/ipv4/ip_forward
	sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux 
	setenforce 0
	swapoff -a
	amazon-linux-extras install epel -y
	yum -y update
	yum -y install git
	git clone https://github.com/kubernetes-sigs/kubespray.git
	cd kubespray/
	pip3 install -r requirements.txt
  export PATH=/usr/local/bin:$PATH
	cp -rfp inventory/sample inventory/gitopscluster
	CONFIG_FILE=inventory/gitopscluster/hosts.yaml python3 contrib/inventory_builder/inventory.py master1,172.16.0.20 master2,172.16.0.21 worker1,172.0.16.30 worker2,172.0.16.31 worker3,172.16.0.32
  
EOT

  tags = {
    Name = "bootstrap"
  }
}


/*
 * ----------worker vm Settings----------
 */


resource "aws_instance" "worker" {
  count         = var.number_of_worker
  ami           = var.amis
  instance_type = var.aws_instance_type
  subnet_id     = aws_subnet.aws-subnet1.id
  key_name      = "test4"  #이미 aws 콘솔에서 만든 key_pair의 이름
  associate_public_ip_address = true
  private_ip                  = cidrhost("172.16.0.0/24", 30 + count.index)
  availability_zone = var.zone
  vpc_security_group_ids = [
    aws_security_group.aws-allow-icmp.id,
    aws_security_group.aws-allow-ssh.id,
    aws_security_group.aws-allow-internet.id,
  ]

 user_data = <<-EOT
    sudo -i
    yum repolist
    yum install nfs-utils nfs-utils-lib
    echo 1 > /proc/sys/net/ipv4/ip_forward
    sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux 
    setenforce 0
    swapoff -a
EOT

  tags = {
    Name = "worker.${count.index}"
  }
}

/*
 * ----------master vm Settings----------
 */

resource "aws_instance" "master" {
    count = var.number_of_controller
    ami = var.amis
    instance_type = var.aws_instance_type
    subnet_id     = aws_subnet.aws-subnet1.id
    key_name      = "test4"  #이미 aws 콘솔에서 만든 key_pair의 이름
    availability_zone = var.zone
    associate_public_ip_address = true
    private_ip                  = cidrhost("172.16.0.0/24", 20 + count.index) 

    vpc_security_group_ids = [
    aws_security_group.aws-allow-icmp.id,
    aws_security_group.aws-allow-ssh.id,
    aws_security_group.aws-allow-internet.id,
  ]

 user_data = <<-EOT
    sudo -i 
    yum repolist
    yum install nfs-utils nfs-utils-lib
    echo 1 > /proc/sys/net/ipv4/ip_forward
    sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux 
    setenforce 0
    swapoff -a
EOT

    tags = {
    Name = "master.${count.index}"
  }
}

/*
 * ----------Output Settings----------
 */

output "kubernetes_bootstrap_public_ip" {
  value = "${join(",", aws_instance.bootstrap.*.public_ip)}"
}

output "kubernetes_masters_public_ip" {
  value = "${join(",", aws_instance.master.*.public_ip)}"
}

output "kubernetes_workers_public_ip" {
  value = "${join(",", aws_instance.worker.*.public_ip)}"
}