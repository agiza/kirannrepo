require 'chefspec'

describe 'infrastructure::chefserver' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::chefserver' }
  it 'should install nokogiri dependencies' do
    %w{gcc make ruby-devel libxml2 libxml2-devel libxslt libxslt-devel}.each do |pkg|
      expect(chef_run).to install_package pkg
    end
  end
  
  it 'should execute bundle install' do
    expect(chef_run).to execute_command('bundle install').with(cwd: '/home/rtnextgen/chef-repo', path: ['/opt/chef/embedded/bin'])
  end
end
