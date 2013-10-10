require 'chefspec'

describe 'realtrans::realtrans-reg' do
  
  REG_PROPS = '/opt/tomcat/conf/realtrans-reg.properties'
  REG_XML = '/opt/tomcat/conf/Catalina/localhost/realtrans-reg.xml'

  before do
  	Chef::Recipe.any_instance.stub(:search).and_return(Hash.new)
  	Chef::Recipe.any_instance.stub(:data_bag_item).and_return(Hash.new)
    Chef::Recipe.any_instance.stub(:data_bag_item)
          .with("infrastructure", "apache")
          .and_return({'rtSPEC' => 'internal.chefspec.com', 
                       'rteSPEC' => 'external.chefspec.com'})
    Chef::Recipe.any_instance.stub(:data_bag_item)
    			.with("rabbitmq", "realtrans")
    			.and_return({"user" => 'wtf|ftw foobar|baz'})
    Chef::Recipe.any_instance.stub(:data_bag_item)
          .with("integration", "mail")
          .and_return({'host' => 'mail.chefspec.com:25', 
                       'user' => 'spec', 
                       'pass' => 'word'})
    Chef::Recipe.any_instance.stub(:data_bag_item)
          .with("integration", "melissadata")
          .and_return({'melissadata' => {'addressurl' => 'address', 
                                         'phoneurl' => 'phone', 
                                         'geocodeurl' => 'geocode', 
                                         'nameurl' => 'name', 
                                         'emailurl' => 'email'}
                                         })
    Chef::Recipe.any_instance.stub(:data_bag_item)
          .with("integration", "ldap")
          .and_return({'ldaphost' => 'ldap.chefspec.com:389',
                        'searchbase' => 'dc=chef,dc=spec,dc=com'})

    Chef::Recipe.any_instance.stub(:data_bag_item)
          .with("infrastructure", "mysqldbSPEC")
          .and_return({ 'realtrans' => {
              'rt_dbname' => 'realtrans',
              'rt_dbuser' => 'realtrans',
              'rt_dbpass' => 'realtrans'
            }})
  end

  it 'should do create a realtrans-reg.properties file in tomcat''s conf directory' do
  	chef_run = ChefSpec::ChefRunner.new(log_level: :info, platform: 'centos',version: '6.3') do |node|
      env = Chef::Environment.new
      env.name 'SPEC'
      node.stub(:chef_environment).and_return env.name
      Chef::Environment.stub(:load).and_return env

      node.automatic_attrs[:ipaddress] = '10.111.222.33'
  		node.set[:realdocproxy] = '10.111.222.1:666'
  		node.set[:rtcenproxy] = '10.111.222.1:667'
  		node.set[:amqpproxy] = '10.111.222.1:668'
      node.set[:amqphost] = 'amqp.chefspec.com'
      node.set[:amqpport] = 100
      node.set[:realtrans_amqp_vhost] = 'vhost'
      node.set[:tenantid] = 'tenantid'
      node.set[:rf_dao_flag] = true
      node.set[:rf_app_config_flag] = true
  	end 
  	chef_run.converge 'realtrans::realtrans-reg'
    chef_run.should create_file REG_PROPS
    chef_run.should create_file_with_content REG_PROPS, 'rf.app.context.path=external.chefspec.com/realtrans-reg'
    chef_run.should_not create_file_with_content REG_PROPS,'rf.app.context.path=internal.chefspec.com/realtrans-reg'
    chef_run.should create_file_with_content REG_PROPS, 'rt.amqp.host=amqp.chefspec.com'
    chef_run.should create_file_with_content REG_PROPS, 'rt.amqp.port=100'
    chef_run.should create_file_with_content REG_PROPS, 'rt.amqp.username=wtf'
    chef_run.should create_file_with_content REG_PROPS, 'rt.amqp.password=ftw'
    chef_run.should create_file_with_content REG_PROPS, 'rt.amqp.virtual-host=vhost'
    chef_run.should create_file_with_content REG_PROPS, 'rf.melissadata.address.webhost=address'
    chef_run.should create_file_with_content REG_PROPS, 'rf.melissadata.phone.webhost=phone'
    chef_run.should create_file_with_content REG_PROPS, 'rf.melissadata.email.webhost=email'
    chef_run.should create_file_with_content REG_PROPS, 'rf.melissadata.geocode.webhost=geocode'
    chef_run.should create_file_with_content REG_PROPS, 'rf.melissadata.name.webhost=name'
    chef_run.should create_file_with_content REG_PROPS, 'rf.email.host=mail.chefspec.com'
    chef_run.should create_file_with_content REG_PROPS, 'rf.email.port=25'
    chef_run.should create_file_with_content REG_PROPS, 'rf.email.username=spec'
    chef_run.should create_file_with_content REG_PROPS, 'rf.email.password=word'
    chef_run.should create_file_with_content REG_PROPS, 'rf.daoAuthenticationProvider.enabled=true'
    chef_run.should create_file_with_content REG_PROPS, 'rf.startupAuthenticationProvider.enabled=false'
    chef_run.should create_file_with_content REG_PROPS, 'rf.overwriteAppConfigArtifacts=true'
    chef_run.should create_file_with_content REG_PROPS, 'rf.sendStacktrace=false'
  end

  it 'should do create a realtrans-reg.xml file in tomcat''s conf/Catalina/localhost directory' do
    chef_run = ChefSpec::ChefRunner.new(log_level: :info, platform: 'centos',version: '6.3') do |node|
      env = Chef::Environment.new
      env.name 'SPEC'
      node.stub(:chef_environment).and_return env.name
      Chef::Environment.stub(:load).and_return env

      node.automatic_attrs[:ipaddress] = '10.111.222.33'
      node.set[:realdocproxy] = '10.111.222.1:666'
      node.set[:rtcenproxy] = '10.111.222.1:667'
      node.set[:amqpproxy] = '10.111.222.1:668'
      node.set[:db_server] = 'db.chefspec.com'
      node.set[:db_port] = 3306
      node.set[:db_maxactive] = 1
      node.set[:db_maxidle] = 0
      node.set[:db_maxwait] = 0
      node.set[:db_timeevict] = 1
      node.set[:db_valquerytimeout] = 1
      node.set[:db_initsize] = 0
    end 
    chef_run.converge 'realtrans::realtrans-reg'
    chef_run.should create_file REG_XML
    chef_run.should create_file_with_content REG_XML, 'url="jdbc:mysql://db.chefspec.com:3306/realtrans?autoReconnect=true"'
    chef_run.should create_file_with_content REG_XML, 'username="realtrans"' 
    chef_run.should create_file_with_content REG_XML, 'password="realtrans"'
    chef_run.should create_file_with_content REG_XML, 'maxActive="1"'
    chef_run.should create_file_with_content REG_XML, 'maxIdle="0"'
    chef_run.should create_file_with_content REG_XML, 'maxWait="0"'
    chef_run.should create_file_with_content REG_XML, 'timeBetweenEvictionRunsMillis="1"'
    chef_run.should create_file_with_content REG_XML, 'validationQueryTimeout="1"'
    chef_run.should create_file_with_content REG_XML, 'initialSize="0"'
  end
end
