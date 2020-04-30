provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

resource "aws_vpc" "customVPC" {
    cidr_block = var.vpcinfo[0].vpcIPAddress
    enable_dns_support = true 
    enable_dns_hostnames = true
    tags = {
      Name = var.vpcinfo[0].vpcName
    }
}

resource "aws_subnet" "PrivSubnets" {
  count = local.PvtSubcount
  vpc_id     =  aws_vpc.customVPC.id
  availability_zone = local.AZS["PrvSubnets"].PvtAZS[count.index]
  cidr_block = var.PrvSubnets[count.index].prvsubnetip
  tags = {
    Name = var.PrvSubnets[count.index].prvsubnetname
    Tier = "Private"
  }
} 

resource "aws_subnet" "PubSubnets" {
  count = local.PubSubcount
  vpc_id     =  aws_vpc.customVPC.id
  availability_zone = local.AZS["PubSubnets"].PubAZS[count.index]
  cidr_block = var.PubSubnets[count.index].pubsubnetip
  map_public_ip_on_launch = true
  tags = {
    Name = var.PubSubnets[count.index].pubsubnetname
  }
}

resource "aws_internet_gateway" "Iggw" {
  vpc_id = aws_vpc.customVPC.id

  tags = {
    Name = join ("",[aws_vpc.customVPC.id, "IgGW"])
  }
}

resource "aws_route_table" "PubRouteTable" {
  vpc_id = aws_vpc.customVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Iggw.id
  }
}

resource "aws_route_table_association" "pubRTAssociation" {
  count = length(aws_subnet.PubSubnets)
  subnet_id      = aws_subnet.PubSubnets[count.index].id
  route_table_id = aws_route_table.PubRouteTable.id
}

resource "aws_eip" "natgweip" {
  count = var.NATGW ? 1 : 0
  vpc = true
  depends_on = [aws_internet_gateway.Iggw]
}

resource "aws_nat_gateway" "natgw" {
  count = var.NATGW ? 1 : 0
  allocation_id = aws_eip.natgweip[count.index].id
  subnet_id     = aws_subnet.PubSubnets[count.index].id

  tags = {
    Name = join ("",[aws_vpc.customVPC.id,"NATGW"])
  }
}

resource "aws_route" "natgwroute" {
  count = var.NATGW ? 1 : 0
  route_table_id  = aws_vpc.customVPC.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.natgw[count.index].id
}