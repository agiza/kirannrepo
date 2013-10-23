require 'chefspec'

describe 'atlassian::artifactory' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'atlassian::artifactory' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
