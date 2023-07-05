build {
    name = "nginx-leedonggyu"

    source "amazon-ebs.ubuntu" {
        name = "nginx"
        ami_name = "nginx-leedonggyu-ami"
    }

    provisioner "shell" {
        inline = [
            "sudo apt-get update",
            "whoami"
        ]
    }

    // 파일을 /tmp/index.html에 cp
    provisioner "file" {
        source = "${path.root}/files/index.html"
        destination = "/tmp/index.html" // 모든 사용자가 접근가능 함 (provioner 특징 상 public한 path...)
    }

    provisioner "shell" {
        inline = [
            "echo ${source.name} and ${source.type}",
            "whoami",
            "sudo apt-get install -y nginx",
            "sudo cp /tmp/index.html /var/www/html/index.html"
        ]
    }

    provisioner "breakpoint" {
        disable = false
        note = "debugging"
    }
}