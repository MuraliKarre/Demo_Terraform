output InstanceID {
    value =  aws_instance.AppInstanceLinux[*].id
}

output InstanceIP {
    value = aws_instance.AppInstanceLinux[*].private_ip
}

output LoadBalancerDNS {
    value = aws_lb.app-nlb.dns_name
}