require 'chefspec'

describe 'infrastructure::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::default' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
