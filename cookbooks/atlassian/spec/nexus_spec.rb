require 'chefspec'

describe 'atlassian::nexus' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'atlassian::nexus' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
