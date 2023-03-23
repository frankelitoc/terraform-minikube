


# < Default VPC >

resource "aws_default_vpc" "default_vpc"{

}

# < Our security group resource to configure public access to our cluster >
resource "aws_security_group" "ssh_cluster" {
  name = "ssh_cluster"
  vpc_id = aws_default_vpc.default_vpc.id

  # SSH access
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   # http
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # minikube
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}


# <Our main EC2 instance which will host our cluster >
resource "aws_instance" "ec2_instance" {
    ami = "ami-06878d265978313ca" # Ubuntu Server 22.04 Free Tier
    instance_type = "t2.medium" 
    key_name = "${var.ssh_key_name}" 
    
    #Script to install minikube
    user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing docker & minikube"
  sudo apt update -y
  sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y
  sudo curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  copy historysudo usermod -aG docker ubuntu && newgrp docker 
  sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  sudo install minikube-linux-amd64 /usr/local/bin/minikube
  echo "*** Completed Installing docker & minikube"
  EOF

    vpc_security_group_ids = [
     aws_security_group.ssh_cluster.id
   ]
}



