require 'chefspec'

describe 'realtrans::realtrans-vp' do
  VP_PROPS = '/opt/tomcat/conf/realtrans-vp.properties'
  VP_XML = '/opt/tomcat/conf/Catalina/localhost/realtrans-vp.xml'

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
                                         'express' => {'webhost' => 'http://xprswbhst'} }
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
    end.converge 'realtrans::realtrans-vp'
  end

  it 'should do create a realtrans-vp.properties file in tomcat''s conf directory' do
    expect(@chef_run).to create_file VP_PROPS
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rf.app.context.path=external.chefspec.com/realtrans-vp'
    expect(@chef_run).to_not create_file_with_content VP_PROPS,'rf.app.context.path=internal.chefspec.com/realtrans-vp'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rt.amqp.host=amqp.chefspec.com'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rt.amqp.port=100'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rt.amqp.username=wtf'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rt.amqp.password=ftw'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rt.amqp.virtual-host=vhost'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rf.melissadata.address.webhost=address'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rf.melissadata.phone.webhost=phone'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rf.melissadata.email.webhost=email'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rf.melissadata.geocode.webhost=geocode'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rf.melissadata.name.webhost=name'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rf.email.host=mail.chefspec.com'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rf.email.port=25'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rf.email.username=spec'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rf.email.password=word'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rf.daoAuthenticationProvider.enabled=true'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rf.startupAuthenticationProvider.enabled=false'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rf.overwriteAppConfigArtifacts=true'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rf.sendStacktrace=false'
  end


  it 'should set logging properties correctly' do
    expect(@chef_run).to create_file VP_PROPS
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rt.logback.maxFileSize=1KB'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rt.logback.maxHistory=1999'
  end

  it 'should do create a realtrans-reg.xml file in tomcat''s conf/Catalina/localhost directory' do
    expect(@chef_run).to create_file VP_XML
    expect(@chef_run).to create_file_with_content VP_XML, 'url="jdbc:mysql://db.chefspec.com:3306/realtrans?autoReconnect=true"'
    expect(@chef_run).to create_file_with_content VP_XML, 'username="realtrans"' 
    expect(@chef_run).to create_file_with_content VP_XML, 'password="realtrans"'
    expect(@chef_run).to create_file_with_content VP_XML, 'maxActive="1"'
    expect(@chef_run).to create_file_with_content VP_XML, 'maxIdle="0"'
    expect(@chef_run).to create_file_with_content VP_XML, 'maxWait="0"'
    expect(@chef_run).to create_file_with_content VP_XML, 'timeBetweenEvictionRunsMillis="1"'
    expect(@chef_run).to create_file_with_content VP_XML, 'validationQueryTimeout="1"'
    expect(@chef_run).to create_file_with_content VP_XML, 'initialSize="0"'
  end

  it 'should populate the new express melissadata properties' do
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rf.melissadata.expressEntry.webhost=http://xprswbhst'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rf.melissadata.expressEntry.allWords=ALL WORDS'
    expect(@chef_run).to create_file_with_content VP_PROPS, 'rf.melissadata.expressEntry.maxMatches=100'
  end  
end
