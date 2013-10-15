require 'chefspec'

describe 'infrastructure::admin' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::admin' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
