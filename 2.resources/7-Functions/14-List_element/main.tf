variable a {
    type = list
    default = [ "Wipro", "Good", "day", "Wipro" ]
}


locals {
    b = element(var.a,1)
}

output b_value {
    value = local.b
}
