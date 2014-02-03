# Mysql DB defaults
default["db_initsize"]          = "2"
default["db_maxactive"]         = "10"
default["db_maxidle"]           = "10"
default["db_maxinactive"]       = "10"
default["db_maxwait"]           = "6000"
default["db_server"]            = "mysqldbprim"
default["db_port"]              = "3306"
default["db_timeevict"]         = "60000"
default["db_valquerytimeout"]   = "2"
# Java defaults for Tomcat
default["java_mem_max"]         = "-Xmx1536m"
default["java_mem_min"]         = "-Xms512m"
default["java_perm_size"]       = "-XX:MaxPermSize=768M"
# Default Integration version attributes
default["intca_version"]          = "0.0.0-1"
default["intcorelogic_version"]   = "0.0.0-1"
default["intdatavision_version"]  = "0.0.0-1"
default["intetrac_version"]       = "0.0.0-1"
default["intinterthinx_version"]  = "0.0.0-1"
default["intrres_version"]        = "0.0.0-1"
default["intrs_version"]          = "0.0.0-1"
default["intsupport_version"]     = "0.0.0-1"
default["intrtl_version"]		  = "0.0.0-1"

default[:int_rs_simulator][:fetch_order_input] = "/opt/tomcat/BPO/input"
default[:int_rs_simulator][:rs_save_order_dir] = "/opt/tomcat/BPO/input"
default[:int_rs_simulator][:poller_delay] = 7000
default[:int_rs_simulator][:rr_save_order_dir] = "/opt/tomcat/CMA/input/In"
default[:int_rs_simulator][:max_order_count] = 50
default[:int_rs_simulator][:max_batch_count] = 50

default[:int_rtl][:ftp][:file_pattern] = "*.json"

default[:int_rtl][:remote][:in_directory] = "/#{node.chef_environment}/PV/input" 
default[:int_rtl][:remote][:archive_directory] = "/#{node.chef_environment}/PV/archive" 
default[:int_rtl][:remote][:error_directory] = "/#{node.chef_environment}/PV/error" 

default[:int_rtl][:amqp][:heartbeat] = 60
default[:int_rtl][:amqp][:exchange][:inbound] = "rt.core.incoming"
default[:int_rtl][:amqp][:exchange][:deadmessages] = "rt.core.deadmessage"
default[:int_rtl][:amqp][:exchange][:monitoring] = "rt.monitoring"

default[:int_rtl][:amqp][:monitoring][:task_executor] = 10
default[:int_rtl][:local][:directory] = "${catalina.base}/pv/input"
default[:int_rtl][:poller_delay] = 120000

default[:integration][:realtrans][:logging][:maxfilesize] = "10MB"
default[:integration][:realtrans][:logging][:maxhistory] = 7
