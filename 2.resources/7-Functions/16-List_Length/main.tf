variable a { 
    type = list
    default = [ "Wipro", "Good", "day", "Wipro" ]
}


locals {
    b = length(var.a)
}

output b_value {
    value = local.b
}
