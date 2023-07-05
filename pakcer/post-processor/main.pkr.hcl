################ source ################
source "amazon-ebs" "ubuntu" {
  instance_type = "t2.micro"
  region        = "ap-northeast-2"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  ssh_username = "ubuntu"
}

################ build ################
build {
    name = "leedonggyu-packer"

    source "amazon-ebs.ubuntu" {
        name = "nginx"
        ami_name = "leedonggyu-nginx"
    }

    provisioner "shell" {
        inline = [
            "echo hello world"
        ]
    }
    
    provisioner "breakpoint" {
        disable =false
        note ="debug"
    }
    
    ## 후처리기...
  post-processor "manifest" {}

  post-processors {
    post-processor "shell-local" {
      inline = ["echo Hello World! > artifact.txt"]
    }
    post-processor "artifice" {
      files = ["artifact.txt"]
    }
    post-processor "compress" {}
  }

  post-processors {
    post-processor "shell-local" {
      inline = ["echo Finished!"]
    }
  }
}