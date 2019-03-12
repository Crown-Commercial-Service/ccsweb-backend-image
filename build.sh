#!/bin/bash
# Packer build script

set -e

# Update system packages
sudo yum update -y

# Add repos required for PHP 7.2
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y install https://centos7.iuscommunity.org/ius-release.rpm

# Install required packages
# NOTE: ruby required for CodeDeploy agent
sudo yum -y install \
    httpd \
    ruby \
    php72u \
    php72u-mysqlnd.x86_64 \
    php72u-opcache \
    php72u-xml \
    php72u-gd \
    php72u-devel \
    php72u-intl \
    php72u-mbstring \
    php72u-bcmath \
    php72u-soap \
    php72u-json

# Apply custom apache config
sudo mv -f ~ec2-user/httpd.conf /etc/httpd/conf/httpd.conf

# Setup AWS CW logging
sudo yum install -y awslogs

sudo chown root:root \
    ~ec2-user/awscli.conf \
    ~ec2-user/awslogs.conf

sudo chmod 640 \
    ~ec2-user/awscli.conf \
    ~ec2-user/awslogs.conf

sudo mv -f \
    ~ec2-user/awscli.conf \
    ~ec2-user/awslogs.conf \
    /etc/awslogs/

sudo systemctl enable awslogsd

# Install CodeDeploy agent
sudo curl -s -o install https://aws-codedeploy-eu-west-1.s3.amazonaws.com/latest/install
sudo chmod +x install
sudo ./install auto
sudo rm -f install
