packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}


variable "docker_image" {
  type    = string
  default = "ubuntu:xenial"
}


source "docker" "ubuntu" {
  image  = var.docker_image
  commit = true
}


build {
  name = "learn-packer"
  sources = [
    "source.docker.ubuntu"
  ]

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo $FOO run on ${var.docker_image}> example.txt"
    ]
  }


  post-processor "docker-tag" {
    repository = "first-ubuntu"
    tags       = ["v1.0"]
  }
}