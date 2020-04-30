provider "aws" {
  version = "~> 2.0"
  region  = "us-east-2"
}

variable var1 {
  default = "val1"
}

variable var2 {
  default = "val2"
}

variable var3 {
  default = "val3"
}

output Value_Of_Variable_var1 {
  value = var.var1
}

output Value_Of_Variable_var2 {
  value = var.var2
}

output Value_Of_Variable_var3 {
  value = var.var3
}
