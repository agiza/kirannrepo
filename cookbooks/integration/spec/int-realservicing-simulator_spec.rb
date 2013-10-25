require 'chefspec'

describe 'integration::int-realservicing-simulator' do
  SIM_PROPS = '/opt/tomcat/conf/realservicing.simulator.properties'
  SIM_XML = '/opt/tomcat/conf/Catalina/localhost/int-realservicing-simulator.xml'

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

    Chef::Recipe.any_instance.stub(:yumserver_search).and_return(Object.new)
    Chef::Recipe.any_instance.stub(:amqphost_search).and_return(Object.new)
    Chef::Recipe.any_instance.stub(:rdochost_search).and_return(Object.new)

	@chef_run =
	  ChefSpec::ChefRunner.new do |node|
        env = Chef::Environment.new
        env.name 'SPEC'
        node.stub(:chef_environment).and_return env.name
        Chef::Environment.stub(:load).and_return env

	  	node.set[:intrs_sim_version] = '1.0.0-SPEC'
	  	node.set[:int_rs_simulator][:fetch_order_input] = '/tmp/fetch'
	  	node.set[:int_rs_simulator][:rs_save_order_dir] = '/tmp/rs-save'
	  	node.set[:int_rs_simulator][:rr_save_order_dir] = '/tmp/rr-save'
	  	node.set[:db_server] = 'db-server'
	  	node.set[:db_port] = 'db-port'
	  	node.set[:db_maxactive] = 1
	  	node.set[:db_maxidle] = 1
	  	node.set[:db_maxwait] = 1
	  	node.set[:db_timeevict] = 0
	  	node.set[:db_valquerytimeout] = 1
	  	node.set[:db_initsize] = 0
	  end.converge 'integration::int-realservicing-simulator'
	
  end

  it 'should include integration default recipe' do
    expect(@chef_run).to include_recipe 'integration::default'
  end

  it 'should install via yum package' do
  	expect(@chef_run).to install_yum_package_at_version 'int-realservicing-simulator','1.0.0-SPEC'
  end

  it 'should set ownership of directories' do
  	expect(@chef_run).to create_directory '/tmp/fetch'
  	expect(@chef_run).to create_directory '/tmp/rs-save'
  	expect(@chef_run).to create_directory '/tmp/rr-save'
  end

  it 'should create a properties file' do
  	expect(@chef_run).to create_file SIM_PROPS
  	expect(@chef_run).to create_file_with_content SIM_PROPS, 'fetchOrder.input.directory=/tmp/fetch'
  	expect(@chef_run).to create_file_with_content SIM_PROPS, 'realServicing.saveOrder.directory=/tmp/rs-save'
  	expect(@chef_run).to create_file_with_content SIM_PROPS, 'fetchOrder.poller.delay=7000'
  	expect(@chef_run).to create_file_with_content SIM_PROPS, 'realResolution.saveOrder.directory=/tmp/rr-save'
  end

  it 'should create a context xml file with mysql settings' do
  	expect(@chef_run).to create_file SIM_XML
  	expect(@chef_run).to create_file_with_content SIM_XML, 'url="jdbc:mysql://db-server:db-port/spec_rtdb?autoReconnect=true"'
  end

end
