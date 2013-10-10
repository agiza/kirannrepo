require 'chefspec'

describe 'realtrans::realtrans-rp' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'realtrans::realtrans-rp' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
