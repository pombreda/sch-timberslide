#
# Cookbook Name:: sch-timberslide
# Recipe:: default
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

# load our LWRPs
include_recipe "python::default"
include_recipe "git_user::default"
include_recipe "chef-sugar::default"

source_repo  = node['timberslide']['repository_url']
source_tag   = node['timberslide']['branch']
requirements = node['timberslide']['pip_requirements'] 
username     = node['timberslide']['username']

Chef::Log.warn("Running with username: #{username}")

# RDS common key
directory "/home/#{username}/.postgresql" do
end

template "/home/#{username}/.postgresql/root.crt" do
  source "rds-ssl-ca-cert.pem"
  mode '0600'
  owner username
  group username
end

# install postgresql client
include_recipe "postgresql::client"

python_version = "python2.6"

if amazon_linux?
  #do AWS Linux stuff
  package "python27-devel"
  python_version = "python2.7"
end


# setup our virtual environemnt
python_virtualenv "/home/#{username}/timberslide_ve" do
  interpreter python_version
  owner username
  group username
  action :create
end

requirements.each_pair do |pkg_name, pkg_version|
  Chef::Log.warn("Installing python module #{pkg_name}")
  python_pip pkg_name do
    version pkg_version
    virtualenv "/home/#{username}/timberslide_ve"
  end
end

# create our git configuration
git_user username do
  private_key node['timberslide']['github']['private_key']
  full_name   "David F. Severski"
  email       "davidski@deadheaven.com"
  known_hosts ['github.com']
end

# create aws profile, or rely upon instance credentials
if node['timberslide']['aws'].nil?
  # we could check for EC2 here
  Chef::Log.warn('No credentials specified - assuming EC2 instance profile')
else
  directory "/home/#{username}/.aws" do
  end

  template "/home/#{username}/.aws/credentials" do
    source "credentials.erb"
    mode '0600'
    owner username
    group username
    variables({
      :region => node['timberslide']['aws']['region'],
      :access_key_id => node['timberslide']['aws']['access_key_id'],
      :secret_access_key => node['timberslide']['aws']['secret_access_key']
    })
  end
end

# create a location for our code to live in
directory '/opt/timberslide' do
    owner username
    group username
    recursive true
end


# download timberslide
git "/opt/timberslide" do
  repository source_repo
  revision   source_tag
  action     :sync
  user       username
end