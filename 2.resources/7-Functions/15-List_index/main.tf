variable a {
    type = list
    default = [ "Wipro", "Good", "day", "Wipro" ]
}


locals {
    b = index(var.a,"Wipro")
}

output b_value {
    value = local.b
}
