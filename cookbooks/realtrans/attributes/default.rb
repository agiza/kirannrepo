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
# Realfoundation Default attributes
default["tenantid"]             = "TENANT1"
default["rf_ldap_flag"]         = "false"
default["rf_dao_flag"]          = "true"
default["access_index"]		= "realtrans"
default["log4j_index"]		= "realtrans"
# Realtrans Default version attributes
default["realtranscentral_version"]	= "0.0.0-1"
default["realtransfp_version"]          = "0.0.0-1"
default["realtransvp_version"]          = "0.0.0-1"
default["realtransreg_version"]         = "0.0.0-1"
# Realtrans default logging attributes
default[:realtrans][:logging][:maxfilesize] = "10MB"
default[:realtrans][:logging][:maxhistory] = 7

# Realtrans default melissadata attributes
default[:realtrans][:melissadata][:expressentry][:webhost] = "https://expressentry.melissadata.net/web/CompleteAddress"
default[:realtrans][:melissadata][:expressentry][:max_matches] = 100
default[:realtrans][:melissadata][:expressentry][:all_words] = ""

default[:realtrans][:amqp][:queue][:pvdata_create] = "rt.core.pvdata.create"
default[:realtrans][:pv][:request_url] = "http://localhost:8080/int-rtlegacy-simulator/PriorValuation.svc/GetPriorValuationDetails"

default[:realtrans][:pv][:legacy_user] = "user"
default[:realtrans][:pv][:legacy_password] = "password"
default[:realtrans][:pv][:fetch_filter] = "alwaysFetchFilter"

# Realtrans default mobile attributes
default[:realtrans][:vp][:mobileEnabled] = "false"

default[:realtrans][:dataquality][:connect_timeout] = 5000
default[:realtrans][:dataquality][:read_timeout] = 5000
default[:realtrans][:dataquality][:max_connections] = 20
default[:realtrans][:dataquality][:max_connections_per_route] = 10

default[:realtrans][:realdoc][:amqpport] = 5672
default[:realtrans][:realdoc][:import_config_code] = "rtng.bulk.import"
