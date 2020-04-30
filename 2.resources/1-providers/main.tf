variable regionname {
    default = "us-east-2"
}

provider "aws" {
    region = "var.regionname"
    version = "~> 2.0"
    }