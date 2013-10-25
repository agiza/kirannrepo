require 'chefspec'

describe 'integration::int-datavision' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'integration::int-datavision' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
