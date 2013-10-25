require 'chefspec'

describe 'integration::int-corelogic' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'integration::int-corelogic' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
