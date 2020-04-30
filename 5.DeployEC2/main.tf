provider "aws" {
  version = "~> 2.0"
  region  = var.region
}


provider "template" {
  version = "~> 2.1.2"
}


data "aws_vpc" "selected" {
  filter {
      name = "tag:Name"
      values = [var.vpc]
  }
  
}

data "aws_subnet_ids" "selected" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = var.ec2subnets
  }
}


data "aws_subnet_ids" "nlbsubnet" {
  vpc_id = data.aws_vpc.selected.id
  
  filter {
  name = "tag:Name"
  values = var.elbsubnets
  }
}


data "aws_ami" "APP_AMI" {
  most_recent      = true
  owners           = ["amazon" , 309956199498, 679593333241, 131827586825]
  
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
  filter {
    name = "name"
    values = [lookup (var.osAMI, var.operatingSystem)]
  }
}

data "template_file" "init-script" {
  count = lookup (var.family, var.operatingSystem) == "Linux" ? 1 : 0
  template = file("${path.module}/source/cloud-init.cfg")
}

data "template_file" "commonVMSetup" {
  count = lookup (var.family, var.operatingSystem) == "Linux" ? 1 : 0
  template = file("${path.module}/source/Common-VM-Activities.wrapper.tpl")
  vars = {
    scriptArgs = local.commonVMSetupExtension["${local.platform}"].scriptArgs,
    }
}

data "template_cloudinit_config" "cloud_init" {
  count = lookup (var.family, var.operatingSystem) == "Linux" ? 1 : 0
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.init-script[0].rendered
  }
  
   part {
    content_type = "text/x-shellscript"
    content = data.template_file.commonVMSetup[0].rendered
  }
}

resource "aws_security_group" "AppServerSg" {
  name        = join("", ["app_", var.serverName ,"_sg" ])
  description = "Security Group for AppServer"
  vpc_id = data.aws_vpc.selected.id

  dynamic ingress {
    for_each = [for rule in local.commonVars[local.platform].inboundList : {
      port  = substr(rule,4,-1)
      protocol  = substr(rule,0,3)
    }]
    content {
      from_port = tonumber(ingress.value.port)
      to_port = tonumber(ingress.value.port)
      protocol = ingress.value.protocol
      cidr_blocks = (length(setintersection([ingress.value.port],[80,443])) == 0 ? [data.aws_vpc.selected.cidr_block] : ["0.0.0.0/0"])
      }
  }    

    dynamic egress {
    for_each = [for rule in local.commonVars[local.platform].outboundList : {
      port  = substr(rule,4,-1)
      protocol  = substr(rule,0,3)
    }]
    
    content {
      from_port = tonumber(egress.value.port)
      to_port = egress.value.port == "0" ? tonumber(65535) : tonumber(egress.value.port)
      protocol = egress.value.protocol
      cidr_blocks = (length(setintersection([egress.value.port],[80,443])) == 0 ? [data.aws_vpc.selected.cidr_block] : ["0.0.0.0/0"])
      }
  }
  
  tags = {
    Name = join("", ["app_", "${var.serverName}","_sg" ])
  }
}

resource "aws_key_pair" "aws-key" {
  key_name   = join("",["aws-key-",var.serverName])
  public_key = var.publicKey
}


resource "aws_instance" "AppInstanceLinux" {
    count = length(var.ec2subnets)
    ami = data.aws_ami.APP_AMI.id
    instance_type = local.commonVars[local.platform].instanceType
    subnet_id = tolist(data.aws_subnet_ids.selected.ids)[count.index]
    vpc_security_group_ids = [aws_security_group.AppServerSg.id]
    iam_instance_profile = var.iam_instance_profile
    key_name = aws_key_pair.aws-key.key_name
    dynamic ebs_block_device {
    for_each = [for disk in var.disks : {
      device_name  = disk.Drive
      volume_size  = disk.DiskSize
    }]
    content {
      device_name = ebs_block_device.value.device_name
      volume_size = ebs_block_device.value.volume_size
      volume_type = lookup (var.storageId, var.osDiskStorageType)
      }
    }
    tags = {
    Name = join("",[var.serverName , count.index + 1 ])
    }
    user_data_base64 = data.template_cloudinit_config.cloud_init[0].rendered
}

resource "aws_lb" "app-nlb" {
  name               = "app-nlb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = tolist(data.aws_subnet_ids.nlbsubnet.ids)

  enable_deletion_protection = false

  tags = {
    Source = "Terraform"
  }
}

resource "aws_lb_target_group" "app-targetgroup" {
  name     = "tf-app-lb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id  = data.aws_vpc.selected.id
}

resource "aws_lb_target_group_attachment" "app-attachment" {
  count = length(var.ec2subnets) 
  target_group_arn = aws_lb_target_group.app-targetgroup.arn
  target_id        = aws_instance.AppInstanceLinux[count.index].id
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.app-nlb.arn
  port              = "80"
  protocol          = "TCP"
  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-targetgroup.arn
  }
}