require 'chefspec'

describe 'realtrans::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'realtrans::default' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
