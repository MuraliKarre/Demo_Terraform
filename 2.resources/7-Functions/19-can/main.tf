variable a {
    type = list
    default = [ "Wipro", "Good", "day", "Wipro" ]
}


locals {
    b = can(index(var.a,"Digital"))
}

output b_value {
    value = local.b
}
