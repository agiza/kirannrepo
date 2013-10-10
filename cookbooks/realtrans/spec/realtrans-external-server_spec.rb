require 'chefspec'

describe 'realtrans::realtrans-external-server' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'realtrans::realtrans-external-server' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
