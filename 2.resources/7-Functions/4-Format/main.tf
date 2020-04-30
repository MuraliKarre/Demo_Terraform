locals {
    val1 = format("There are %d students in this virtual class",123)
}

output val1_value {
    value = local.val1
}

