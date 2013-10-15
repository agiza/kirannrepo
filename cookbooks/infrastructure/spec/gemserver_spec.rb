require 'chefspec'

describe 'infrastructure::gemserver' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::gemserver' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
