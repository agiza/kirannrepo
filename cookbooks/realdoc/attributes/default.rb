# Java defaults for Tomcat
default['java_mem_max'] = '-Xmx1536m'
default['java_mem_min'] = '-Xms512m'
default['java_perm_size'] = '-XX:MaxPermSize=768M'
# Mysql DB defaults
default['db_initsize'] = '2'
default['db_maxactive'] = '50'
default['db_maxidle'] = '50'
default['db_maxinactive'] = '10'
default['db_maxwait'] = '6000'
default['db_server'] = 'mysqldbprim'
default['db_port'] = '3306'
default['db_timeevict'] = '60000'
default['db_valquerytimeout'] = '2'
# Oracle DB defaults default['oradb_server'] = '50.19.6.17' default['oradb_port'] = '1521'
default['validation_query'] = 'SELECT 1 from dual'
default['ordb_maxactive'] = '500'
default['ordb_maxidle'] = '500'
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
        :xml_basedir => '/opt/tomcat/correspondence',
        :tp2_presplit_dir => '/opt/tomcat/incoming/tp2',
        :tp2_postsplit_dir => '/opt/tomcat/incoming/processed-tp2',
        :tp2_max_lines => 1000,
        :io_basedir => '/opt/tomcat/correspondence',
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
default[:libreoffice] = {
    :bin_dir => '/usr/lib64/libreoffice',
    :working_dir => '/tmp/libreoffice',
    :ports => '8200,8201,8202,8203,8204,8205,8206,8207,8208,8209',
    :core_war_ports => '8210,8211,8212,8213,8214,8215,8216,8217,8218,8219'
}
default[:altisource][:altitomcat][:setenv_cmds] = 'pkill -u tomcat -f "libreoffice.*headless"'

default[:task_management] = {
    :auto_assign => true,
    :num_tasks_per_group => 25
}

default['rf_job_flag'] = 'false'
#Generating correspondence
default['rd_corres_flag'] = 'false'
default['rd_mongo_conns'] = '50'
default['rd_corres_delivery'] = '10'
default['rd_corres_dispatch'] = '20'
default['rd_corres_batch'] = '10'
default['rd_corres_recon'] = '10'
default['rd_corres_retry'] = '1'
#storage 
default['rd_storage_method'] = 'GRID_FS'
default['rd_corr_storage_method'] = 'GRID_FS'
default['rd_pig_storage_method'] = 'GRID_FS'
default['rd_dconv_storage_method'] = 'GRID_FS'
#correspondence-request ports (microservice)
default[:microservice] = {
    :maitred_app_port => '17200',
    :maitred_adm_port => '18200'
}
#ods_adapter values
default[:ods_adapter] = {
         :mongo => {   
          :host => 'localhost'
          },
         :schedule => 'Every(5mn)',
         :db => {
          :driver_class => 'oracle.jdbc.driver.OracleDriver',
          :user => 'user',
          :password => 'password',
          :url => '<change me>',
          :max_wait_conn => '15s',
          :min_size => '8',
          :initial_size => '10',
          :max_size => '32',
          :validation_interval => '60s',
          :min_idle_time => '1 minute'
          },
         :logging => {
          :log_level => 'DEBUG',
          :log_file_count => '3'
          },
         :app_port => '19200',
         :admin_port => '20200',
         :aggregation_thread_poolsize => '<change me>',
         :delivery_thread_poolsize => '10',
         :req_items_split_threshold => '<change me>',
         :letter_req_schema_name => 'LETTER_DB_QA'
}
#maitred
default[:maitred] = {
         :host => 'localhost',
         :app_port => '17200',
         :admin_port => '18200',
         :db => {
          :driver_class => 'com.mysql.jdbc.Driver',
          :user => 'user',
          :password => 'password',
          :url => '<change me>',
          :max_wait_conn => '1s',
          :min_size => '8',
          :max_size => '32'
        },
        :logging => {
         :log_level => 'DEBUG',
         :log_file_count => '3'
    },
}
 
