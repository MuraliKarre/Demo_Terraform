variable region {
    default = "us-east-2"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.region
}


data "aws_ami" "EC2_AMI" {
  most_recent      = true
  owners           = ["amazon" ]
  
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
    values = ["suse-sles-12-sp1-v????????-hvm-ssd-x86_64"]
  }
}

output AMI_ID {
    value = data.aws_ami.EC2_AMI.id
}

output AMI_NAME {
    value = data.aws_ami.EC2_AMI.name
}