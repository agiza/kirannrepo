require 'chefspec'

describe 'integration::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'integration::default' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
