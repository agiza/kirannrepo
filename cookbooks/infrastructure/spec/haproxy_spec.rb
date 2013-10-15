require 'chefspec'

describe 'infrastructure::haproxy' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::haproxy' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
