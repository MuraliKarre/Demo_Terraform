# Arithematic Expressions 
##########################
variable x {
    default = 25
}

variable y {
    default = 2
}

locals {
    add = var.x + var.y 
    subtract = var.x - var.y 
}

output add_value {
    value = local.add
}

output sub_value {
    value = local.subtract
}

## Conditional Expression 

variable a {
    default = 24
}

variable b {
    default = 45
}

locals {
    cond = var.a < var.b ? "Variable a less than variable b":"Variable a greather than variable b"
}

output cond_result {
    value = local.cond
}

## List Indexes

variable list1 {
    type = list(string)
    default = ["Hello","Digies","Welcome","to","Terraform","Training"]
}

output list_index {
    value= var.list1[2]
}
