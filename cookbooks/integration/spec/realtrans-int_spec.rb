require 'chefspec'

describe 'integration::realtrans-int' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'integration::realtrans-int' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
