require 'chefspec'

describe 'atlassian::atlassian-cli' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'atlassian::atlassian-cli' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
