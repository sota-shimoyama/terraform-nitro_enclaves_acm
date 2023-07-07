#!/bin/bash

set -ex

# install httpd
yum -y install httpd
systemctl start httpd
systemctl enable httpd

yum install -y mod_ssl

# Install RPM package
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
REGION_NAME=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed -e 's/.$//')
yum install -y https://s3.${REGION_NAME}.amazonaws.com/amazon-ssm-${REGION_NAME}/latest/linux_arm64/amazon-ssm-agent.rpm

# Restart SSM agent
systemctl restart amazon-ssm-agent

# Install nitro-enclaves
amazon-linux-extras enable aws-nitro-enclaves-cli
yum install aws-nitro-enclaves-acm -y