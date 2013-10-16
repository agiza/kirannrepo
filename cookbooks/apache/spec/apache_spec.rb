require 'chefspec'

describe 'apache::apache' do
  LOGROTATE = '/etc/logrotate.d/httpd'

  before do
    Chef::Recipe.any_instance.stub(:data_bag_item).and_return(Hash.new)
    Chef::Recipe.any_instance.stub(:search).and_return(Hash.new)
    Chef::Recipe.any_instance.stub(:yumserver_search).and_return(Object.new)
  end

  let (:chef_run) do 
  	ChefSpec::ChefRunner.new do |node|
	    node.set[:yum_server] = 'yum-test'
	    node.set[:yumserver] = 'yum-test'
	    node.set[:yumserver_search] = 'yum-test'
  	end.converge 'apache::apache'
  end

  it 'should create a log rotation file' do
    expect(chef_run).to create_file LOGROTATE
  end

  it 'should create a log rotation file with expected behavior' do
    expect(chef_run).to create_file_with_content LOGROTATE,
    	/\/var\/log\/httpd\/\*log \{.*?(?=sharedscripts.*?service httpd reload).*\}/m
  end
end
