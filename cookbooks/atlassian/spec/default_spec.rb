require 'chefspec'

describe 'atlassian::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'atlassian::default' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
