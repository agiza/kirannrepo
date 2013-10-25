require 'chefspec'

describe 'integration::int-etrac' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'integration::int-etrac' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
