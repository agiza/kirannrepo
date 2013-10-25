require 'chefspec'

describe 'integration::int-realresolution' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'integration::int-realresolution' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
