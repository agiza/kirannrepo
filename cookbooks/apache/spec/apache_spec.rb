require 'chefspec'

describe 'apache::apache' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'apache::apache' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
