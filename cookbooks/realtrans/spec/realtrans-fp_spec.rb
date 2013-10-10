require 'chefspec'

describe 'realtrans::realtrans-fp' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'realtrans::realtrans-fp' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
