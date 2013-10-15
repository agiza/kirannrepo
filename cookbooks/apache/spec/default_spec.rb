require 'chefspec'

describe 'apache::default' do
  before do
    Chef::Recipe.any_instance.stub(:data_bag_item).and_return(Hash.new)
    Chef::Recipe.any_instance.stub(:search).and_return(Hash.new)
    Chef::Recipe.any_instance.stub(:yumserver_search).and_return(Object.new)
  end
 
  let (:chef_run) { 
    chef_run = ChefSpec::ChefRunner.new
    chef_run.node.set[:yum_server] = 'yum-test'
    chef_run.node.set[:yumserver] = 'yum-test'
    chef_run.node.set[:yumserver_search] = 'yum-test'
    chef_run.converge 'apache::default' 
    chef_run
  }
  it 'should include the rt recipes' do
    expect(chef_run).to include_recipe "apache::apache"
    %w{l1vhost rdvhost rfvhost rtevhost rtvhost}.each do |vhost|
      expect(chef_run).to include_recipe "apache::"+vhost
    end
  end
end
