#
# Cookbook Name:: sch-timberslide
# Attributes:: default
#
default['timberslide']['pip_requirements'] = {
    'argparse' => '1.3.0',
    'boto'     => '2.35.1',
    'psycopg2' => '2.5.4',
    'pytz'     => '2014.10'}
default['timberslide']['repository_url'] = 'https://github.com/mlsecproject/timberslide.git'
default['timberslide']['branch'] = 'master'
default['timberslide']['username'] = 'vagrant'

#AWS RDS parameters
default['timberslide']['database_info']['name']                 = 'timberslide'
default['timberslide']['database_info']['instance_type']        = 'db.m3.large'
default['timberslide']['database_info']['size']                 = 10
default['timberslide']['database_info']['username']             = 'lumberjack'
default['timberslide']['database_info']['password']             = 'supersecure'
default['timberslide']['database_info']['vpc_security_groups']  = 'default'
default['timberslide']['database_info']['tags']                 = { 'project' => 'timberslide' }
default['timberslide']['database_info']['publicly_accessible']  = false
default['timberslide']['database_info']['db_subnet']            = 'rds-subnet'
default['timberslide']['database_info']['multi_az']             = false
default['timberslide']['database_info']['retention_period']     = 0
default['timberslide']['database_info']['storage_encrypted']    = true
default['timberslide']['database_info']['kms_id']               = 'your_kms_id'