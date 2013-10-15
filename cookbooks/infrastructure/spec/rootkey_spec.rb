require 'chefspec'

describe 'infrastructure::rootkey' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::rootkey' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
