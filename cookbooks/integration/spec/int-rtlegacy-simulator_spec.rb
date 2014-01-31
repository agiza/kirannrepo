require 'chefspec'

describe 'integration::int-rtlegacy-simulator' do
  PROPS = '/opt/tomcat/conf/int-rtlegacy-simulator.properties'

  before do
  	Chef::Recipe.any_instance.stub(:search).and_return(Hash.new)
  	Chef::Recipe.any_instance.stub(:data_bag_item).and_return(Hash.new)
    Chef::Recipe.any_instance.stub(:yumserver_search).and_return(Object.new)
    Chef::Recipe.any_instance.stub(:amqphost_search).and_return(Object.new)
    Chef::Recipe.any_instance.stub(:rdochost_search).and_return(Object.new)

	@chef_run =
	  ChefSpec::ChefRunner.new do |node|
        env = Chef::Environment.new
        env.name 'SPEC'
        node.stub(:chef_environment).and_return env.name
        Chef::Environment.stub(:load).and_return env

	  	node.set[:intrtl_sim_version] = '1.0.0-SPEC'
	  end.converge 'integration::int-rtlegacy-simulator'
	
  end

  it 'should include integration default recipe' do
    expect(@chef_run).to include_recipe 'integration::default'
  end

  it 'should install via yum package' do
  	expect(@chef_run).to install_yum_package_at_version 'int-rtlegacy-simulator','1.0.0-SPEC'
  end
end