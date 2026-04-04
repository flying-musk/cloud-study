provider "aws" {
  region = "us-west-1"
}

resource "aws_security_group" "mars_sg" {
  name        = "mars-cloud-sg-tf"
  description = "Security group created by Terraform to match manual settings"

  # 1. SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 2. HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 3. HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 4. Grafana (安全考量：只限你目前的 IP)
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["128.195.97.213/32"] # 照抄你截圖裡的 IP
  }

  # 5. RedisInsight
  ingress {
    from_port   = 5540
    to_port     = 5540
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 對外全開
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "mars_server" {
  ami           = "ami-0cbd40f694b804622" 
  instance_type = "t2.micro"
  key_name      = "mars-key" 

  vpc_security_group_ids = [aws_security_group.mars_sg.id]

  tags = {
    Name = "Mars-Terraform-Server"
  }
}