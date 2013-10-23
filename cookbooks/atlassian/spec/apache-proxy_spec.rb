require 'chefspec'

describe 'atlassian::apache-proxy' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'atlassian::apache-proxy' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
