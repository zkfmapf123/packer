# Pakcer (이미지 빌드도구)

## Execute

```
    cd /infra
    terraform init && terraform apply

    cd packer
    packer init . && packer build .
```

## Packer 동작과정

```
    packer init .
    packer build .

    => Create Temporary keypair
    => Create Temporary sg (inbound 22)
    => Create Temporary EC2 machine (기재된 내용의 ami)
    => connect to 22 port
    => packer source에 빌드된 내용을 설치
    => Delete Temporary sg (inboud 22)
    => Delete Temporary keypair
    => Delete EC2
    => Snapshot AMI

```

## Pakcer 삭제 과정

- AMI 등록취소
- EBS 스냅샷 삭제 (Create by ...)

## Packer 특징

> 모든 Build는 Build 블록에서 이뤄짐

- terraform 과 같이 선언형 언어이므로 순서는 중요하지 않음

```hcl
    // source.pkr.hcl
    source "null" "one" {
         communicator = "none"
    }

    source "null" "two" {
        communicator = "none"
    }

    // main.pkr.hcl
    build {
        sources = [
            "source.null.one",
            "source.null.two"
        ]
    }

    build {
        name = "leedonggyu" // naming

        sources = [
            "source.null.one",
            "source.null.two"
        ]
    }
```

> source 블록자체의 필요한 항목들을 build 블록에서 정의 가능함

- 두개의 ami를 띄우는데 각각 항목당 provisioning 코드가 4개씩임..

```
    build {
    source "amazon-ebs.ubuntu" {
        name = "example"
        ami_name = "leedonggyu-v1"
    }

    source "amazon-ebs.ubuntu" {
        name = "example-2"
        ami_name = "leedonggyu-v2"
    }

    provisioner "shell" {
        inline = [
            "echo hello world!! = 1"
        ]
    }

    provisioner "shell" {
        inline = [
            "echo hello world!! = 2"
        ]
    }

    provisioner "shell" {
        inline = [
            "echo hello world!! = 3"
        ]
    }

    provisioner "shell" {
        inline = [
            "echo hello world!! = 4"
        ]
    }
}
```

## Todo 1. nginx ami

```
    cd packer/nginx
```
