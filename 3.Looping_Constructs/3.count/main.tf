provider "aws" {
  version = "~> 2.0"
  region  = "us-east-2"
}

variable vpc {
    default = "sap-vpc"
}

variable sg_Name {
    default = "terrasg"
}

variable inboundList {
    type = list(string)
    default = ["TCP-22","TCP-443","TCP-80"]
}

variable outboundList {
    type = list(string)
    default = ["TCP-443","TCP-80"]
}

data "aws_vpc" "selected" {
  filter {
      name = "tag:Name"
      values = ["${var.vpc}"]
  }
}

resource "aws_security_group" "terraformsg" {
  count = length(var.inboundList) 
  name        = join("",[ var.sg_Name , tostring(count.index + 1)])
  description = "Security Group created by Terraform"
  vpc_id = data.aws_vpc.selected.id

  dynamic ingress {
    for_each = [for rule in var.inboundList : {
      port  = substr(rule,4,-1)
      protocol  = substr(rule,0,3)
    }]
    content {
      from_port = tonumber(ingress.value.port)
      to_port = tonumber(ingress.value.port)
      protocol = ingress.value.protocol
      cidr_blocks = [data.aws_vpc.selected.cidr_block]
      }
  }    

    dynamic egress {
    for_each = [for rule in var.outboundList : {
      port  = substr(rule,4,-1)
      protocol  = substr(rule,0,3)
    }]
    
    content {
      from_port = tonumber(egress.value.port)
      to_port = egress.value.port == "0" ? tonumber(65535) : tonumber(egress.value.port)
      protocol = egress.value.protocol
      cidr_blocks = [data.aws_vpc.selected.cidr_block]
      }
  }
  tags = {
    Name = join("",[ var.sg_Name , tostring(count.index + 1)])
  }
  
  
}

output sg_id {
    value = aws_security_group.terraformsg[*].id
}