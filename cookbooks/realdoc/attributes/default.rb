# Java defaults for Tomcat
default["java_mem_max"]         = "-Xmx1536m"
default["java_mem_min"]         = "-Xms512m"
default["java_perm_size"]       = "-XX:MaxPermSize=768M"
# Mysql DB defaults
default["db_initsize"]		= "2"
default["db_maxactive"]		= "10"
default["db_maxidle"]		= "10"
default["db_maxinactive"]	= "10"
default["db_maxwait"]		= "6000"
default["db_server"]		= "mysqldbprim"
default["db_port"]		= "3306"
default["db_timeevict"]		= "60000"
default["db_valquerytimeout"]	= "2"
# Mysql realdoc app defaults
default["rdoc_dbname"]		= "realdoc"
default["rdocdb_user"]		= "real_app"
default["rdocdb_pass"]		= "0ch3N'OK"
# Mysql strongmail adapter defaults
default["smadap_dbname"]        = "strongmail"
default["smadapdb_user"]        = "strm_admin"
default["smadapdb_pass"]        = "0ch3N'OK"
# Mysql realsvc-recon adapter defaults
default["recon_dbname"]         = "realdoc"
default["recondb_user"]         = "real_app"
default["recondb_pass"]         = "0ch3N'OK"
# Mysql jdbc adapter defaults
default["jdbcpr_dbname"]        = "realdoc"
default["jdbcprdb_user"]        = "real_app"
default["jdbcprdb_pass"]        = "0ch3N'OK"
# Mongodb defaults
default["mongodb_database"]	= "realdoc"
default["mongodb_pass"]		= "guest"
default["mongodb_user"]		= "guest"
# FTP Server defaults
default["realdoc_ftphost"]	= "10.0.0.20"
default["realdoc_ftppass"]	= "none"
default["realdoc_ftpport"]	= "22"
default["realdoc_ftpuser"]	= "realdoc"
# Realdoc Rabbit default vhost
default["realdoc_amqp_vhost"]	= "/realdoc"

