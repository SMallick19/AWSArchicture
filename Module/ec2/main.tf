resource "aws_security_group" "web" {
  name        = "${var.environment}-web-sg"
  description = "Security group for web EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress{
    description = "Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-web-sg"
    environment = var.environment
    managedby   = "Terraform"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]  

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

    filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "web" {
    ami                    = data.aws_ami.amazon_linux.id
    instance_type          = var.instance_type
    subnet_id              = var.subnet_id
    vpc_security_group_ids = [
        aws_security_group.web.id
    ]
    associate_public_ip_address = true
    user_data = templatefile("${path.module}/user_data.sh", {
        docker_image = var.docker_image
    })
    tags = {
        Name        = "${var.environment}-hello-world"
        environment = var.environment
        managedby   = "Terraform"
    }
}