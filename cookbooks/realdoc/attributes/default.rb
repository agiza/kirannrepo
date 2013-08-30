# Java defaults for Tomcat
default["java_mem_max"] = "-Xmx1536m"
default["java_mem_min"] = "-Xms512m"
default["java_perm_size"] = "-XX:MaxPermSize=768M"
# Mysql DB defaults
default["db_initsize"] = "2"
default["db_maxactive"] = "10"
default["db_maxidle"] = "10"
default["db_maxinactive"] = "10"
default["db_maxwait"] = "6000"
default["db_server"] = "mysqldbprim"
default["db_port"] = "3306"
default["db_timeevict"] = "60000"
default["db_valquerytimeout"] = "2"
# Oracle DB defaults
default["oradb_server"] = "50.19.6.17"
default["oradb_port"] = "1521"
# Mongodb defaults
default["mongodb_database"] = "realdoc"
default["mongodb_pass"] = "guest"
default["mongodb_user"] = "guest"
# Realfoundation Default attributes
default["tenantid"] = "TENANT1"
default["rf_ldap_flag"] = "false"
default["rf_dao_flag"] = "true"
default["access_index"] = "realdoc"
default["log4j_index"] = "realdoc"
# Realdoc Default version attributes
default["realdoc_version"] = "0.0.0-1"
default["jdbcprov_version"] = "0.0.0-1"
default["rdcorr_version"] = "0.0.0-1"
default["rdmailmerge_version"] = "0.0.0-1"
default["rdproxygen_version"] = "0.0.0-1"
default["rdtranscentrarecon_version"] = "0.0.0-1"
default["reconadapter_version"] = "0.0.0-1"
default["smadapter_version"] = "0.0.0-1"
default["rdcorradap_version"] = "0.0.0-1"
# Adapters
default['adapters'] = {
    :rs_inbound => {
        :xml_basedir => '${catalina.base}/correspondence',
        :tp2_dir => '${catalina.base}/correspondence',
        :io_basedir => '${catalina.base}/correspondence',
        :xml_poll_freq => 3000
    },
    :rs_outbound => {
        :ftp => {
            :host => "",
            :port => "",
            :username => "",
            :key_file => "",
            :output_dir => "",
            :use => "false"
        },
        :output => {
            :directory => "/tmp",
            :suppression_filename => "realdoc-email-suppression.txt",
            :text_filename => "realdoc-reconfile.txt",
            :blacklist_filename => "realdoc-blacklist.txt"
        }
    }
}
