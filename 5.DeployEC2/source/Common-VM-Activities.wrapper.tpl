#!/bin/bash
cd /tmp
OSVER=`grep -w "ID" /etc/os-release|cut -d"\"" -f 2`
if [ $OSVER == "rhel" ]; then 
  yum install unzip wget epel-release openssl-devel libnghttp2-devel libidn-devel gcc firewalld -y
elif [ $OSVER == "ol" ]; then 
  sudo yum install unzip -y 
fi
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
aws s3 cp "s3://wipro-cmp/Terraform/Generic-VM-Activities.sh" "/tmp/Generic-VM-Activities.sh"
chmod 755 "/tmp/Generic-VM-Activities.sh"
sudo /tmp/Generic-VM-Activities.sh ${scriptArgs}