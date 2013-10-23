require 'chefspec'

describe 'atlassian::bamboo' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'atlassian::bamboo' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
