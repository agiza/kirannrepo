require 'chefspec'

describe 'atlassian::confluence' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'atlassian::confluence' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
