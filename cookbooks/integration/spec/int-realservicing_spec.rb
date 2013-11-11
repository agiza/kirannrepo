require 'chefspec'

describe 'integration::int-realservicing' do

  RS_PROPS_FILE = '/opt/tomcat/conf/int-realservicing.properties'

  before do
  	Chef::Recipe.any_instance.stub(:search).and_return(Hash.new)
  	Chef::Recipe.any_instance.stub(:data_bag_item).and_return(Hash.new)
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
	  end.converge 'integration::int-realservicing'
  end

  it 'should set logging parameters correctly' do
    expect(@chef_run).to create_file RS_PROPS_FILE
    expect(@chef_run).to create_file_with_content RS_PROPS_FILE,'rt.int.rs.logback.maxFileSize=1KB'
    expect(@chef_run).to create_file_with_content RS_PROPS_FILE,'rt.int.rs.logback.maxHistory=1999'  
  end

  it 'should set amqp parameters correctly' do
    expect(@chef_run).to create_file_with_content RS_PROPS_FILE,'rt.int.amqp.host=rabbitmq'
    expect(@chef_run).to create_file_with_content RS_PROPS_FILE,'rt.int.amqp.port=211'
    expect(@chef_run).to create_file_with_content RS_PROPS_FILE,'rt.int.amqp.username=test'
    expect(@chef_run).to create_file_with_content RS_PROPS_FILE,'rt.int.amqp.password=spec'
    expect(@chef_run).to create_file_with_content RS_PROPS_FILE,'rt.int.amqp.virtual-host=vhost'
  end

end
