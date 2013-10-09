require 'bundler/setup'
require 'chefspec'

describe 'apache::rtvhost' do
  PROXY_CONF = 'rt-SPEC.proxy.conf'

  before do
  	Chef::Recipe.any_instance.stub(:search).and_return(Hash.new)
  	%w(realtrans-fp realtrans-central realtrans-reg realtrans-vp realtrans-server).each do |app|
  		Chef::Recipe.any_instance.stub(:search)
  					.with(:node, "recipes:*\\:\\:#{app}")
  					.and_return([{'chef_environment' => 'SPEC'}])
  		Chef::Recipe.any_instance.stub(:search)
  					.with(:node, "recipes:*\\:\\:#{app} AND chef_environment:SPEC")
  					.and_return([{"ipaddress" => '10.111.222.33'}])
    end

  	Chef::Recipe.any_instance.stub(:data_bag_item).and_return(Hash.new)
    Chef::Recipe.any_instance.stub(:data_bag_item)
    			.with("infrastructure", "apache")
    			.and_return({"serveripallow" => '10.111.222.31 10.111.222.32'})

    Chef::Recipe.any_instance.stub(:yumserver_search).and_return(Object.new)
  end

  it 'should create a rt-SPEC.proxy.conf file with standard settings' do
  	chef_run = ChefSpec::ChefRunner.new(log_level: :info, platform: 'centos',version: '6.3') do |node|
  		node.set[:yum_server] = 'yum-test'
  		node.set[:yumserver] = 'yum-test'
  		node.automatic_attrs[:ipaddress] = '10.111.222.34'
  	end 
  	chef_run.converge 'apache::apache','apache::rtvhost'
    chef_run.should create_file_with_content "/etc/httpd/proxy.d/#{PROXY_CONF}",
    	"BalancerMember http://10.111.222.33:8080 route=10.111.222.33"
    chef_run.should create_file_with_content "/etc/httpd/proxy.d/#{PROXY_CONF}",
    	"Allow from 10.111.222.31"
    chef_run.should create_file_with_content "/etc/httpd/proxy.d/#{PROXY_CONF}",
    	"<Location /realtrans-central>"
    chef_run.should create_file_with_content "/etc/httpd/proxy.d/#{PROXY_CONF}",
    	"ProxyPass balancer://realtrans-fp-SPEC/realtrans-fp stickysession=JSESSIONID|jsessionid"
    chef_run.should create_file_with_content "/etc/httpd/proxy.d/#{PROXY_CONF}",
      "ProxyPass balancer://realtrans-central-SPEC/realtrans-central stickysession=JSESSIONID|jsessionid"
  end

  it 'should create a rt-SPEC.proxy.conf file with overridden port' do
  	chef_run = ChefSpec::ChefRunner.new(log_level: :info, platform: 'centos',version: '6.3') do |node|
  		node.set[:yum_server] = 'yum-test'
  		node.set[:yumserver] = 'yum-test'
  		node.set[:apache][:workers][:port] = 1999
  		node.automatic_attrs[:ipaddress] = '10.111.222.34'
  	end 
  	chef_run.converge 'apache::apache','apache::rtvhost'
    chef_run.should create_file_with_content "/etc/httpd/proxy.d/#{PROXY_CONF}",
    	"BalancerMember http://10.111.222.33:1999 route=10.111.222.33"
    chef_run.should create_file_with_content "/etc/httpd/proxy.d/#{PROXY_CONF}",
      /<Proxy balancer:\/\/realtrans-central-SPEC>.*?(?=BalancerMember http:\/\/10.111.222.33:8080).*?<\/Proxy>/m
  end

  it 'should create a rt-SPEC.proxy.conf file respecting secure_proxy' do
    chef_run = ChefSpec::ChefRunner.new(log_level: :info, platform: 'centos',version: '6.3') do |node|
      node.set[:yum_server] = 'yum-test'
      node.set[:yumserver] = 'yum-test'
      node.set[:altisource][:altitomcat][:secure_proxy] = true
      node.automatic_attrs[:ipaddress] = '10.111.222.34'
    end 
    chef_run.converge 'apache::apache','apache::rtvhost'
    chef_run.should create_file_with_content "/etc/httpd/proxy.d/#{PROXY_CONF}",
      "BalancerMember http://10.111.222.33:8000 route=10.111.222.33"
    chef_run.should create_file_with_content "/etc/httpd/proxy.d/#{PROXY_CONF}",
      /<Proxy balancer:\/\/realtrans-central-SPEC>.*?(?=BalancerMember http:\/\/10.111.222.33:8080).*?<\/Proxy>/m
  end
end