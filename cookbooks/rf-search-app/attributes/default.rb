
################################################################################
### RealSearch properties
#################################################################################
#
#Tomcat properties
#
default['rf-search-app']['tomcat']['setenv_catalina_opts'] = "-XX:PermSize=512M -XX:MaxPermSize=1024m -XX:-UseSplitVerifier -Djava.awt.headless=true"

#RPM's versions
#
default['realsearch-searchservice']['rpm']['version'] = '1.0.0-RC'
default['realsearch-indexservice']['rpm']['version'] = '1.0.0-RC'

# Search Engine Configurations
default['realsearch']['elasticsearch']['server']['host'] = nil
default['realsearch']['elasticsearch']['server']['port'] = 9300
default['realsearch']['elasticsearch']['cluster']['name'] = 'rf-realsearch'
default['realsearch']['solr']['connectionString'] = 'http://localhost:8953/solr'
#
##Rabbit MQ Configuration
default['realsearch']['indexservice']['amqp']['host'] = nil
default['realsearch']['indexservice']['amqp']['port'] = 5672
default['realsearch']['indexservice']['amqp']['username'] = 'realsearch'
default['realsearch']['indexservice']['amqp']['password'] = 'realsearch12'
default['realsearch']['indexservice']['amqp']['vhost'] = 'realsearch'
#
#Queue Declaration
default['realsearch']['indexservice']['amqp']['insert']['request'] = 'realsearch.data.insert.queue'
default['realsearch']['indexservice']['amqp']['update']['request'] = 'realsearch.data.update.queue'
default['realsearch']['indexservice']['amqp']['delete']['request'] = 'realsearch.data.delete.queue'
default['realsearch']['indexservice']['amqp']['audit']['request'] = 'realsearch.data.audit.queue'

#
##Multiple consumers configruation
default['realsearch']['indexservice']['index']['concurrent']['consumers'] = 20
default['realsearch']['indexservice']['index']['threadpool']['size'] = 20
default['realsearch']['indexservice']['index']['prefetch']['count'] = 20
default['realsearch']['indexservice']['audit']['concurrent']['consumers'] = 10
default['realsearch']['indexservice']['audit']['threadpool']['size'] = 10
default['realsearch']['indexservice']['audit']['prefetch']['count'] = 20

#
##
default['realsearch']['indexservice']['action']['insert'] = 'realsearch.data.insert'
default['realsearch']['indexservice']['action']['update'] = 'realsearch.data.update'
default['realsearch']['indexservice']['action']['delete'] = 'realsearch.data.delete'
default['realsearch']['indexservice']['action']['audit'] = 'realsearch.data.audit'

default['realsearch']['indexservice']['update']['retries'] = 4

default['realsearch']['documentation']['services']['basePath'] = 'http://localhost:8080/searchservice'
default['realsearch']['documentation']['services']['version'] = '1.0'

#others
default['realsearch']['app_search_es'] = "chef_environment:#{node.chef_environment} AND elasticsearch_cluster_name:*"
default['realsearch']['app_search_rq'] = "chef_environment:#{node.chef_environment} AND rf-rabbitmq-master:*"