require 'chefspec'

describe 'realtrans::realtrans-server' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'realtrans::realtrans-server' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
