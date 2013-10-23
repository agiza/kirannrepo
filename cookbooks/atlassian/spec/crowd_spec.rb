require 'chefspec'

describe 'atlassian::crowd' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'atlassian::crowd' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
