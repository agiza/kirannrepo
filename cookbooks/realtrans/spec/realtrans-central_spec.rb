require 'chefspec'

describe 'realtrans::realtrans-central' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'realtrans::realtrans-central' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
