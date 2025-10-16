packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  type    = string
  default = "us-east-2"
}

source "amazon-ebs" "amazon_linux_2023" {
  ami_name      = "amazon-linux-2023-hardened-{{timestamp}}"
  instance_type = "t3.micro"
  region        = var.region

  source_ami_filter {
    filters = {
      name                = "al2023-ami-*-x86_64"
      virtualization-type = "hvm"
      architecture        = "x86_64"
      root-device-type    = "ebs"
    }
    owners      = ["137112412989"]
    most_recent = true
  }

  ssh_username = "ec2-user"

  tags = {
    Name        = "AmazonLinux2023-Hardened"
    Environment = "Dev"
    Owner       = "Wesley Marshall"
    Purpose     = "CIS Hardening + Apache Setup"
  }

  temporary_security_group_source_cidrs = ["0.0.0.0/0"]
}

build {
  sources = ["source.amazon-ebs.amazon_linux_2023"]

  provisioner "shell" {
    inline = [
      "echo 'Running CIS hardening script...'",
      "curl -O /mnt/c/Users/wesle/Desktop/DEVOPS/packer-ami-project/scripst/cis-hardening.sh",
      "chmod +x cis-hardening.sh",
      "sudo ./cis-hardening.sh"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'Installing Apache (httpd)...'",
      "sudo dnf install -y httpd",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "echo '<h1>Welcome to your hardened AMI</h1>' | sudo tee /var/www/html/index.html"
    ]
  }
}
