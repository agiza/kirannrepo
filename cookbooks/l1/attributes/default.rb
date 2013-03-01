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
default["tenantid"]             = "L1_TENANT"
default["rf_ldap_flag"]         = "false"
default["rf_dao_flag"]          = "true"
default["access_index"]         = "lendersone"
default["log4j_index"]          = "lendersone"
# Default version attributes
default["l1central_version"]    = "0.0.0-1"
default["l1fp_version"]         = "0.0.0-1"
default["l1rp_version"]         = "0.0.0-1"
