require 'chefspec'

describe 'altisource::altitomcat' do

  SERVER_XML = '/opt/tomcat/conf/server.xml'

  it 'should create a server.xml file without secure_proxy information with defaults' do
	chef_run = ChefSpec::ChefRunner.new(log_level: :info, platform: 'centos',version: '6.3') do |node|
		node.set[:yum_server] = 'yum-test'
		node.automatic_attrs[:ipaddress] = '10.111.222.33'
	end 
	chef_run.converge 'altisource::altitomcat'
    chef_run.should create_file SERVER_XML
    chef_run.should create_file_with_content SERVER_XML, 'jvmRoute="10.111.222.33"'
    chef_run.should_not create_file_with_content SERVER_XML,'port="8000"'
  end

  it 'should create a server.xml file with secure_proxy information if supplied' do
	chef_run = ChefSpec::ChefRunner.new(log_level: :info, platform: 'centos',version: '6.3') do |node|
		node.set[:yum_server] = 'yum-test',
		node.set[:altisource][:altitomcat][:secure_proxy] = true
		node.automatic_attrs[:ipaddress] = '10.111.222.33'
	end 
	chef_run.converge 'altisource::altitomcat'
    chef_run.should create_file SERVER_XML
    chef_run.should create_file_with_content SERVER_XML, 'jvmRoute="10.111.222.33"'
    chef_run.should create_file_with_content SERVER_XML,'port="8000"'
  end

  IPTABLES_RULE = '/etc/iptables.d/port_tomcat'
  IPTABLES_SECPXY_RULE = '/etc/iptables.d/secure_proxy_port_tomcat'

  it 'should open port 8080 in the firewall' do
	chef_run = ChefSpec::ChefRunner.new(log_level: :info, platform: 'centos',version: '6.3') do |node|
		node.set[:yum_server] = 'yum-test',
		node.automatic_attrs[:ipaddress] = '10.111.222.33'
	end 
	chef_run.converge 'altisource::altitomcat'
	chef_run.should create_file IPTABLES_RULE
	chef_run.should create_file_with_content IPTABLES_RULE,'-A FWR -p tcp -m tcp --dport 8080 -j ACCEPT'
	chef_run.should_not create_file_with_content IPTABLES_SECPXY_RULE,'-A FWR -p tcp -m tcp --dport 8000 -j ACCEPT'
  end

  it 'should open port 8000 in the firewall if secure_proxy is set' do
	chef_run = ChefSpec::ChefRunner.new(log_level: :info, platform: 'centos',version: '6.3') do |node|
		node.set[:yum_server] = 'yum-test',
		node.set[:altisource][:altitomcat][:secure_proxy] = true
		node.automatic_attrs[:ipaddress] = '10.111.222.33'
	end 
	chef_run.converge 'altisource::altitomcat'
	chef_run.should create_file IPTABLES_RULE
	chef_run.should create_file_with_content IPTABLES_RULE,'-A FWR -p tcp -m tcp --dport 8080 -j ACCEPT'
	chef_run.should create_file_with_content IPTABLES_SECPXY_RULE,'-A FWR -p tcp -m tcp --dport 8000 -j ACCEPT'
  end
end