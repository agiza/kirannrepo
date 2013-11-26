# Java defaults for Tomcat
default['java_mem_max'] = '-Xmx1536m'
default['java_mem_min'] = '-Xms512m'
default['java_perm_size'] = '-XX:MaxPermSize=768M'
# Mysql DB defaults
default['db_initsize'] = '2'
default['db_maxactive'] = '10'
default['db_maxidle'] = '10'
default['db_maxinactive'] = '10'
default['db_maxwait'] = '6000'
default['db_server'] = 'mysqldbprim'
default['db_port'] = '3306'
default['db_timeevict'] = '60000'
default['db_valquerytimeout'] = '2'
# Oracle DB defaults
default['oradb_server'] = '50.19.6.17'
default['oradb_port'] = '1521'
default['validation_query'] = 'SELECT 1 from dual'
# Mongodb defaults
default['mongodb_database'] = 'realdoc'
default['mongodb_pass'] = ''
default['mongodb_user'] = ''
# Realfoundation Default attributes
default['tenantid'] = 'TENANT1'
default['rf_ldap_flag'] = 'false'
default['rf_dao_flag'] = 'true'
default['access_index'] = 'realdoc'
default['log4j_index'] = 'realdoc'
# Realdoc Default version attributes
default['realdoc_version'] = '0.0.0-1'
default['jdbcprov_version'] = '0.0.0-1'
default['rdcorr_version'] = '0.0.0-1'
default['rdmailmerge_version'] = '0.0.0-1'
default['rdproxygen_version'] = '0.0.0-1'
default['rdtranscentrarecon_version'] = '0.0.0-1'
default['reconadapter_version'] = '0.0.0-1'
default['smadapter_version'] = '0.0.0-1'
default['rdcorradap_version'] = '0.0.0-1'
default['tp2_adapter_version'] = '0.0.0-1'
# Adapters
default[:adapters] = {
    :rs_inbound => {
        :xml_basedir => '${catalina.base}/correspondence',
        :tp2_presplit_dir => '${catalina.base}/incoming/tp2',
        :tp2_postsplit_dir => '${catalina.base}/incoming/processed-tp2',
        :tp2_max_lines => 1000,
        :io_basedir => '${catalina.base}/correspondence',
        :done_file_suffix => '.tag',
        :xml_poll_freq => 3000
    },
    :rs_outbound => {
        :amqp => {
            :queue_name => 'rd.legacy.adapter'
        },
        :ftp => {
            :host => '',
            :port => 22,
            :username => '',
            :key_file => '',
            :output_dir => '',
            :use => 'false'
        },
        :output => {
            :done_file_suffix => '.tag',
            :directory => '${catalina.base}/correspondence/recon',
            :suppression_filename => 'realdoc-email-suppression.txt',
            :text_filename => 'realdoc-reconfile.txt',
            :blacklist_filename => 'realdoc-blacklist.txt'
        }
    }
}
# strongmail db configuration
default[:strongmail_db] = {
    :connection_string => '<change me>:3306/strongmail?autoReconnect=true',
    :type => 'mysql',
    :schema => 'strongmail',
    :initial_size => '2',
    :max_active => '10',
    :max_idle => '10',
    :max_inactive => '10',
    :max_wait => '6000',
    :eviction_interval => '60000',
    :validation_timeout => '2'
}

# nested database configuration
default[:dbs] = {
    :mysql => {
        :type => 'mysql',
        :schema => '',
        :host => 'mysqldbprim',
        :port => '3306',
        :initial_size => '2',
        :max_active => '10',
        :max_idle => '10',
        :max_inactive => '10',
        :max_wait => '6000',
        :eviction_interval => '60000',
        :validation_timeout => '2'
    },
    :oracle => {
        :type => 'oracle',
        :schema => '',
        :host => '50.19.6.17',
        :port => '1521'
    }
}
