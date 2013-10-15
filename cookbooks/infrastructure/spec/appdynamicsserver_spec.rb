require 'chefspec'

describe 'infrastructure::appdynamicsserver' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::appdynamicsserver' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
