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
# Mysql realtrans app defaults
default["l1_dbname"]          = "lendersone"
default["l1db_user"]          = "real_app"
default["l1db_pass"]          = "0ch3N'OK"
# Java defaults for Tomcat
default["java_mem_max"]         = "-Xmx1536m"
default["java_mem_min"]         = "-Xms512m"
default["java_perm_size"]       = "-XX:MaxPermSize=768M"