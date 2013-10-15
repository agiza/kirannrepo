require 'chefspec'

describe 'infrastructure::hostname' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::hostname' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
