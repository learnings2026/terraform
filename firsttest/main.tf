provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "terraform-ec2-sg"
  description = "Security group for Terraform EC2 lab"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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

# Generate an RSA key pair
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Register the public key with AWS
resource "aws_key_pair" "deployer" {
  key_name   = "terraform-ec2-key"
  public_key = tls_private_key.this.public_key_openssh
}

# Save the private key locally so you can use it with ssh
resource "local_file" "private_key" {
  content         = tls_private_key.this.private_key_pem
  filename        = "terraform-ec2-key.pem"
  file_permission = "0400"
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  key_name        = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.ec2_sg.name]

  associate_public_ip_address = true

  tags = {
    Name        = "terraform-ec2-lab"
    Environment = "lab"
  }
}

output "instance_id" {
  value = aws_instance.ec2.id
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}

