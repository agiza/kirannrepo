#
# Cookbook Name:: rf_iam_liquibase
# Attributes:: default
#

default[:liquibase][:version]      = "3.1.1"
default[:liquibase][:install_path] = "/opt/liquibase-#{node[:liquibase][:version]}"

# override[:java][:openjdk_packages] = ["openjdk-7-jdk", "openjdk-7-jre-headless"]
# override[:java][:openjdk_packages] = ["java-1.7.0-openjdk", "java-1.7.0-openjdk-devel"]

#default['mysql_connector']['j']['version'] = "5.1.31"

default[:rf_iam_liquibase][:change_log_file] = "master-db-changelog.xml"
default[:rf_iam_liquibase][:connection][:driver] = "com.mysql.jdbc.Driver"
default[:rf_iam_liquibase][:connection][:adapter] = "mysql"
default[:rf_iam_liquibase][:connection][:host] = "#{node[:ipaddress]}"
default[:rf_iam_liquibase][:connection][:port] = "3306"
default[:rf_iam_liquibase][:connection][:database] = "rfng_iam"
default[:rf_iam_liquibase][:connection][:username] = "root"
default[:rf_iam_liquibase][:connection][:password] = "realmysql"