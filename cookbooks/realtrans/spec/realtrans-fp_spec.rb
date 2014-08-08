require 'chefspec'

describe 'realtrans::realtrans-fp' do

  FP_PROPS = '/opt/tomcat/conf/realtrans-fp.properties'
  FP_XML = '/opt/tomcat/conf/Catalina/localhost/realtrans-fp.xml'

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
                                         'emailurl' => 'email',
                                         'express' => { 'webhost' => 'http://xprswbhst'} }
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

    @chef_run = ChefSpec::ChefRunner.new do |node|
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
  		node.set[:db_server] = 'db.chefspec.com'
  		node.set[:db_port] = 3306
  		node.set[:db_maxactive] = 1
  		node.set[:db_maxidle] = 0
  		node.set[:db_maxwait] = 0
  		node.set[:db_timeevict] = 1
  		node.set[:db_valquerytimeout] = 1
  		node.set[:db_initsize] = 0
  		node.set[:realtrans][:logging][:maxfilesize] = '1KB'
  		node.set[:realtrans][:logging][:maxhistory] = 1999
      node.set[:realtrans][:melissadata][:expressentry][:all_words] = 'ALL WORDS'
      node.set[:realtrans][:dataquality][:connect_timeout] = 1500
  	end.converge 'realtrans::realtrans-fp'
  end

  it 'should do create a realtrans-fp.properties file in tomcat''s conf directory' do
    expect(@chef_run).to create_file FP_PROPS
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rt.amqp.host=amqp.chefspec.com'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rt.amqp.port=100'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rt.amqp.username=wtf'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rt.amqp.password=ftw'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rt.amqp.virtual-host=vhost'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.melissadata.address.webhost=address'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.melissadata.phone.webhost=phone'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.melissadata.email.webhost=email'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.melissadata.geocode.webhost=geocode'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.melissadata.name.webhost=name'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.email.host=mail.chefspec.com'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.email.port=25'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.email.username=spec'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.email.password=word'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.daoAuthenticationProvider.enabled=true'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.startupAuthenticationProvider.enabled=false'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.overwriteAppConfigArtifacts=true'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.sendStacktrace=false'
  end

  it 'should set logging properties correctly' do
    expect(@chef_run).to create_file FP_PROPS
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rt.logback.maxFileSize=1KB'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rt.logback.maxHistory=1999'
  end

  it 'should do create a realtrans-fp.xml file in tomcat''s conf/Catalina/localhost directory' do
    expect(@chef_run).to create_file FP_XML
    expect(@chef_run).to create_file_with_content FP_XML, 'url="jdbc:mysql://db.chefspec.com:3306/realtrans?autoReconnect=true"'
    expect(@chef_run).to create_file_with_content FP_XML, 'username="realtrans"' 
    expect(@chef_run).to create_file_with_content FP_XML, 'password="realtrans"'
    expect(@chef_run).to create_file_with_content FP_XML, 'maxActive="1"'
    expect(@chef_run).to create_file_with_content FP_XML, 'maxIdle="0"'
    expect(@chef_run).to create_file_with_content FP_XML, 'maxWait="0"'
    expect(@chef_run).to create_file_with_content FP_XML, 'timeBetweenEvictionRunsMillis="1"'
    expect(@chef_run).to create_file_with_content FP_XML, 'validationQueryTimeout="1"'
    expect(@chef_run).to create_file_with_content FP_XML, 'initialSize="0"'
  end

  it 'should populate the new express melissadata properties' do
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.melissadata.expressEntry.webhost=http://xprswbhst'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.melissadata.expressEntry.allWords=ALL WORDS'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.melissadata.expressEntry.maxMatches=100'
  end

  it 'should include the new pv properties' do
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rt.amqp.queue.pvdata.create=rt.core.pvdata.create'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rt.previous.valuations.requestUrl=http://localhost:8080/int-rtlegacy-simulator/PriorValuation.svc/GetPriorValuationDetails'
  end

  it 'should include the pv fetch filter property' do
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rt.previous.valuations.order.filter=alwaysFetchFilter'
  end

  it 'should populate the dataquality properties' do 
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.dataquality.connectTimeout=1500'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.dataquality.readTimeout=5000'

    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.dataquality.httpPool.maxTotal=20'
    expect(@chef_run).to create_file_with_content FP_PROPS, 'rf.dataquality.httpPool.defaultMaxPerRoute=10'
  end
end
