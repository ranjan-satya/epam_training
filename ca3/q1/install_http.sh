#!/bin/bash

yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo "<h1> Hi! This task is performed during CA3 in webserver 1. </h1>" > /var/www/html/index.html