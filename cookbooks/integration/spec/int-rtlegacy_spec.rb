require 'chefspec'

describe 'integration::int-rtlegacy' do
  PROPS = '/opt/tomcat/conf/int-rtlegacy.properties'

  before do
  	Chef::Recipe.any_instance.stub(:search).and_return(Hash.new)
  	Chef::Recipe.any_instance.stub(:data_bag_item).and_return(Hash.new)
    Chef::Recipe.any_instance.stub(:data_bag_item)
          .with("rabbitmq", "realtrans")
          .and_return({ 'user' => 'test|spec'})
    Chef::Recipe.any_instance.stub(:data_bag_item)
          .with("integration", "rtlegacySPEC")
          .and_return({ :ftphost => 'ftp.spec:22', 
          				:user => 'ftpuser', 
          				:pass => 'ftppass' })

    Chef::Recipe.any_instance.stub(:yumserver_search).and_return(Object.new)
    Chef::Recipe.any_instance.stub(:amqphost_search).and_return(Object.new)
    Chef::Recipe.any_instance.stub(:rdochost_search).and_return(Object.new)

	@chef_run =
	  ChefSpec::ChefRunner.new do |node|
        env = Chef::Environment.new
        env.name 'SPEC'
        node.stub(:chef_environment).and_return env.name
        Chef::Environment.stub(:load).and_return env

	  	node.set[:intrtl_version] = '1.0.0-SPEC'
	  	node.set[:int_rtl][:amqp][:exchange][:inbound] = 'spec.xchg.in'
	  	node.set[:int_rtl][:remote][:in_directory] = '/tmp/rtl-in'
	  	node.set[:int_rtl][:local][:directory] = '/tmp/rtl'
		node.set[:int_rtl][:amqp][:heartbeat] = 3
        node.set[:amqphost] = 'rabbitmq'
        node.set[:amqpport] = 211
        node.set[:realtrans_amqp_vhost] = 'vhost'
        node.set[:integration][:realtrans][:logging][:maxfilesize] = '1KB'
        node.set[:integration][:realtrans][:logging][:maxhistory] = 1999
	  end.converge 'integration::int-rtlegacy'
	
  end

  it 'should include integration default recipe' do
    expect(@chef_run).to include_recipe 'integration::default'
  end

  it 'should install via yum package' do
  	expect(@chef_run).to install_yum_package_at_version 'int-rtlegacy','1.0.0-SPEC'
  end

  it 'should set ownership of directories' do
  	expect(@chef_run).to create_directory '/tmp/rtl'
  end

  it 'should create a properties file' do
  	expect(@chef_run).to create_file PROPS
  end

  it 'should create a properties file with contents' do
  	expect(@chef_run).to create_file_with_content PROPS, 'rt.int.rtlegacy.ftp.host=ftp.spec'
  	expect(@chef_run).to create_file_with_content PROPS, 'rt.int.rtlegacy.ftp.user=ftpuser'
  	expect(@chef_run).to create_file_with_content PROPS, 'rt.int.rtlegacy.filename.pattern=*.json'
  	expect(@chef_run).to create_file_with_content PROPS, 'rt.int.rtlegacy.remote.in.directory=/tmp/rtl-in'
  	expect(@chef_run).to create_file_with_content PROPS, 'rt.int.amqp.username=test'
  	expect(@chef_run).to create_file_with_content PROPS, 'rt.int.amqp.password=spec'
  	expect(@chef_run).to create_file_with_content PROPS, 'rt.int.amqp.exchange.messages.inbound=spec.xchg.in'
  	expect(@chef_run).to create_file_with_content PROPS, 'rt.int.amqp.rt.core.deadmessage=rt.core.deadmessage'
  	expect(@chef_run).to create_file_with_content PROPS, 'rt.int.monitoring.taskExecutor.poolSize=10'
  end

end