require 'chefspec'

describe 'integration::int-interthinx' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'integration::int-interthinx' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
