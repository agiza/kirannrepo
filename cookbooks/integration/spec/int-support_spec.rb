require 'chefspec'

describe 'integration::int-support' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'integration::int-support' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
