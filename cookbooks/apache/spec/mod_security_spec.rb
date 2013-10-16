require 'chefspec'

describe 'apache::mod_security' do
  MOD_SECURITY = '/etc/httpd/conf.d/mod_security.conf'

  before do
    Chef::Recipe.any_instance.stub(:data_bag_item).and_return(Hash.new)

    Chef::Recipe.any_instance.stub(:data_bag_item)
        		.with("infrastructure", "apache")
    			.and_return({"bodylimit" => '1234567890'})

    Chef::Recipe.any_instance.stub(:search).and_return(Hash.new)
    Chef::Recipe.any_instance.stub(:yumserver_search).and_return(Object.new)
  end

  let (:chef_run) do
  	ChefSpec::ChefRunner.new do |node|

  	end.converge 'apache::mod_security' 
  end

  it 'should create the mod_security.conf file' do
  	expect(chef_run).to create_file MOD_SECURITY
  end

  it 'should set the body limit per the data bag' do
    expect(chef_run).to create_file_with_content MOD_SECURITY, 'SecRequestBodyLimit 1234567890'
  end

  it 'should make the MULTIPART_UNMATCHED_BOUNDARY rule log-only' do
    expect(chef_run).to create_file_with_content MOD_SECURITY, 
    	/SecRule MULTIPART_UNMATCHED_BOUNDARY "!@eq 0"\s*\\\s*"id:'200003',phase:2,t:none,log,auditlog,pass/m
  end

  it 'should set logging to sane values' do
    expect(chef_run).to create_file_with_content MOD_SECURITY, /SecDebugLogLevel\s+3/
  end

  it 'should return sane status codes on a MULTIPART failure' do
    expect(chef_run).to create_file_with_content MOD_SECURITY, 
    	/SecRule MULTIPART_STRICT_ERROR "!@eq 0"\s*\\\s*"id:'200002',phase:2,t:none,log,deny,status:400,msg:'Multipart request body/m
  end 
end
