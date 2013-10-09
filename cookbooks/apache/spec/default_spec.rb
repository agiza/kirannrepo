require 'chefspec'

describe 'apache::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'apache::default' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
