resource "aws_instance" "web" {
  ami                    = "ami-0326f9264af7e51e2"
  instance_type          = "t2.large"
  associate_public_ip_address = true
  key_name               = "key3"
  vpc_security_group_ids = ["sg-0286f68d4d5aeb153"]  # Provided as a list
  user_data              = templatefile("./install.sh", {})
  subnet_id = "subnet-08e0bfabfae3c76cf"


  tags = {
    Name = "Jenkins-SonarQube"
    
  }

  root_block_device {
    volume_size = 40
  }
}

resource "aws_security_group" "Jenkins-VM-SG" {
  name        = "Jenkins-VM-SG"
  description = "Allow TLS inbound traffic"
  vpc_id = "vpc-0b4b6156dc517013a"
  

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-VM-SG"
  }
}