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
default["access_index"]         = "hubzu"
default["log4j_index"]          = "hubzu"
# Default version attributes
default["hubzu_version"]	= "0.0.0-1"
default["hubzubo_version"]	= "0.0.0-1"
default["hubzuac_version"]	= "0.0.0-1"
# Recipe defaults for hubzu-accounts - override these in data bags or environment roles
default["hubzu_ac_dbname"]	= "namedefault"
# db.url=jdbc:mysql://localhost:3306/realsuite
# db.username=realsuite
# db.password=realsuite
# db.showsql=true
# db.driver=com.mysql.jdbc.Driver
#
