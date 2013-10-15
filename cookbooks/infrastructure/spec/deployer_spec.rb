require 'chefspec'

describe 'infrastructure::deployer' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::deployer' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
