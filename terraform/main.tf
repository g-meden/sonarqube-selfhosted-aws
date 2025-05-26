# terraform/main.tf

provider "aws" {
  region = "us-east-2"  # Feel free to change to your region
}

resource "aws_key_pair" "sonarqube_key" {
  key_name   = "sonarqube-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_security_group" "sonarqube_sg" {
  name        = "sonarqube-sg"
  description = "Allow SSH and SonarQube web access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allwed_ip]
   # cidr_blocks = ["0.0.0.0/0"]  # Restrict in real setup
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip]
  # cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "sonarqube" {
  ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu 22.04 in us-east-2
  instance_type = "t3.medium"
  instance_type = "t3.medium"             # Enough RAM for SonarQube
  key_name      = aws_key_pair.sonarqube_key.key_name
  security_groups = [aws_security_group.sonarqube_sg.name]

  user_data = file("${path.module}/install-sonarqube.sh")

  tags = {
    Name = "SonarQube-Instance"
  }
}
