require 'chefspec'

describe 'integration::l1-int' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'integration::l1-int' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
