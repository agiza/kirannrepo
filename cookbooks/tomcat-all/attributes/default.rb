# O.S. related settings
default['tomcat-all']['user'] = 'tomcat'
default['tomcat-all']['group'] = 'tomcat'

# Tomcat related settings
## installation
default['tomcat-all']['version'] = '7.0.53'
default['tomcat-all']['install_directory'] = '/opt'
## configuration
default['tomcat-all']['shutdown_port'] = '8005'
default['tomcat-all']['port'] = '8080'
default['tomcat-all']['max_threads'] = '100'
default['tomcat-all']['min_spare_threads'] = '10'
default['tomcat-all']['java_opts'] = '-Xmx3g -XX:PermSize=512M -XX:MaxPermSize=1024m -d64 -server -Djava.awt.headless=true'
