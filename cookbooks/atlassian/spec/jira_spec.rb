require 'chefspec'

describe 'atlassian::jira' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'atlassian::jira' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
