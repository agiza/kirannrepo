require 'chefspec'

describe 'realtrans::realtrans-vp' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'realtrans::realtrans-vp' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
