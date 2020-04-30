output "VPCID" {
    value = "${aws_vpc.customVPC.id}"
}

output "PrvSubnetIDs" {
    value = "${aws_subnet.PrivSubnets.*.id}"
}

output "PubSubnetIDs" {
    value = "${aws_subnet.PubSubnets.*.id}"
}