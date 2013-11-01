require 'chefspec'

describe 'altisource::jacoco-agent' do

  before do
  	Chef::Recipe.any_instance.stub(:search).and_return(Hash.new)
  	Chef::Recipe.any_instance.stub(:data_bag_item).and_return(Hash.new)

  end

  it 'should create the install directory' do
    chef_run = 
	 	ChefSpec::ChefRunner.new do |node|
			node.set[:yum_server] = 'yum-test'
	 		node.set[:altisource][:jacoco_agent][:install_dir] = '/tmp/specdir'
	   	end.converge 'altisource::jacoco-agent'

    expect(chef_run).to create_directory('/tmp/specdir')
    directory = chef_run.directory('/tmp/specdir')
    expect(directory).to be_owned_by('root', 'root')
  end

  it 'should download the remote file' do
    chef_run = 
	 	ChefSpec::ChefRunner.new do |node|
			node.set[:yum_server] = 'yum-test'
	 		node.set[:altisource][:jacoco_agent][:install_dir] = '/tmp/specdir'
	 		node.set[:altisource][:jacoco_agent][:version] = '1.0.spec'
	 		node.set[:altisource][:jacoco_agent][:repo_url] = 'http://localhost/repo'
	   	end.converge 'altisource::jacoco-agent'

    expect(chef_run).to create_remote_file('/tmp/specdir/jacoco_agent_package.zip').with(
    	:source => "http://localhost/repo/org/jacoco/org.jacoco.agent/1.0.spec/org.jacoco.agent-1.0.spec.jar",
    	:mode => '0644',
    	:owner => 'root',
    	:group => 'root'
    )
  end

  it 'should trigger running an extraction' do
    chef_run = 
	 	ChefSpec::ChefRunner.new do |node|
			node.set[:yum_server] = 'yum-test'
	 		node.set[:altisource][:jacoco_agent][:install_dir] = '/tmp/specdir'
	 		node.set[:altisource][:jacoco_agent][:version] = '1.0.spec'
	 		node.set[:altisource][:jacoco_agent][:repo_url] = 'http://localhost/repo'
	   	end.converge 'altisource::jacoco-agent'

	remote_file = chef_run.remote_file('/tmp/specdir/jacoco_agent_package.zip')
	expect(remote_file).to notify 'execute[extract_agent_jar]', :run

	expect(chef_run).to execute_command('unzip jacoco_agent_package.zip jacocoagent.jar && chmod 644 jacocoagent.jar').with(
		  :cwd => '/tmp/specdir'
		)
  end

end
