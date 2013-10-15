require 'chefspec'

describe 'infrastructure::rabbitproxy' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::rabbitproxy' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
