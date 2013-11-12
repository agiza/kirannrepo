require 'chefspec'

describe 'integration::int-realresolution' do

  RRES_PROPS_FILE = '/opt/tomcat/conf/int-realresolution.properties'

  before do
  	Chef::Recipe.any_instance.stub(:search).and_return(Hash.new)
  	Chef::Recipe.any_instance.stub(:data_bag_item).and_return(Hash.new)
    Chef::Recipe.any_instance.stub(:data_bag_item)
          .with("infrastructure", "mysqldbSPEC")
          .and_return({ 'realtrans' => {
              'rt_dbname' => 'spec_rtdb',
              'rt_dbuser' => 'spec_rtusr',
              'rt_dbpass' => 'spec_rtpwd'
            }})

    Chef::Recipe.any_instance.stub(:data_bag_item)
          .with("integration", "realresolutionSPEC")
          .and_return({ 'ftphost' => 'ftp.spec:22', 'user' => 'ftpuser', 'pass' => 'ftppass' })

    Chef::Recipe.any_instance.stub(:data_bag_item)
          .with("rabbitmq", "realtrans")
          .and_return({ 'user' => 'test|spec'})

    Chef::Recipe.any_instance.stub(:yumserver_search).and_return(Object.new)
    Chef::Recipe.any_instance.stub(:amqphost_search).and_return(Object.new)
    Chef::Recipe.any_instance.stub(:rdochost_search).and_return(Object.new)

	@chef_run =
	  ChefSpec::ChefRunner.new do |node|
        env = Chef::Environment.new
        env.name 'SPEC'
        node.stub(:chef_environment).and_return env.name
        Chef::Environment.stub(:load).and_return env

        node.set[:amqphost] = 'rabbitmq'
        node.set[:amqpport] = 211
        node.set[:realtrans_amqp_vhost] = 'vhost'
        node.set[:integration][:realtrans][:logging][:maxfilesize] = '1KB'
        node.set[:integration][:realtrans][:logging][:maxhistory] = 1999
	  end.converge 'integration::int-realresolution'
  end

  it 'should set logging parameters correctly' do
    expect(@chef_run).to create_file RRES_PROPS_FILE
    expect(@chef_run).to create_file_with_content RRES_PROPS_FILE,'rt.int.rres.logback.maxFileSize=1KB'
    expect(@chef_run).to create_file_with_content RRES_PROPS_FILE,'rt.int.rres.logback.maxHistory=1999'  
  end

  it 'should set amqp parameters correctly' do
    expect(@chef_run).to create_file_with_content RRES_PROPS_FILE,'rt.int.amqp.host=rabbitmq'
    expect(@chef_run).to create_file_with_content RRES_PROPS_FILE,'rt.int.amqp.port=211'
    expect(@chef_run).to create_file_with_content RRES_PROPS_FILE,'rt.int.amqp.username=test'
    expect(@chef_run).to create_file_with_content RRES_PROPS_FILE,'rt.int.amqp.password=spec'
    expect(@chef_run).to create_file_with_content RRES_PROPS_FILE,'rt.int.amqp.virtual-host=vhost'
  end

  it 'should set ftp parameters correctly' do
    expect(@chef_run).to create_file_with_content RRES_PROPS_FILE,'rt.int.rres.ftp.host=ftp.spec'
    expect(@chef_run).to create_file_with_content RRES_PROPS_FILE,'rt.int.rres.ftp.port=22'
    expect(@chef_run).to create_file_with_content RRES_PROPS_FILE,'rt.int.rres.ftp.user=ftpuser'
    expect(@chef_run).to create_file_with_content RRES_PROPS_FILE,'rt.int.rres.ftp.pwd=ftppass'
  end
end
