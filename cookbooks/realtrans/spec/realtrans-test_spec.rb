require 'chefspec'

describe 'realtrans::realtrans-test' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'realtrans::realtrans-test' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
