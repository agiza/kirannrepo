require 'chefspec'

describe 'infrastructure::appdynamics' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::appdynamics' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
