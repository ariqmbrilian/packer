packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.02"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "packer-linux-aws-apache"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    environment_vars = [
      "FOO=hello",
    ]
    inline = [
      "echo Installing nginx",
      "sleep 30s",
      "sudo apt update",
      "sudo apt install apache2 -y",
      "echo $FOO > example.txt"

    ]
  }

  post-processor "vagrant" {}
  post-processor "compress" {}
}