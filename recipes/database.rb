#
# Cookbook Name:: sch-timberslide
# Recipe:: database
#
# Copyright (C) 2015 David F. Severski
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

Chef::Log.warn("Database creation is not tested or supported! Caveat Emptor!")

# load our LWRPs
include_recipe "aws-sdk::default"
include_recipe "aws-rds::default"

# fetch RDS parameters
db_info = node['timberslide']['database_info']

# create our RDS instance
aws_rds db_info['name'] do
  engine                  'postgres'
  db_instance_class       db_info['instance_type']
  allocated_storage       db_info['size']
  master_username         db_info['username']
  master_user_password    db_info['password']
  vpc_security_group_ids  db_info['vpc_security_groups']
  tags                    db_info['tags']
  publicly_accessible     db_info['publicly_accessible']
  multi_az                db_info['multi_az']
  backup_retention_period db_info['retention_period']
  db_subnet_group_name    db_info['db_subnet']
end

# output instance connection point
Chef::Log.info("RDS instance created at: #{node['aws_rds'][db_info['name']]}")