require 'chefspec'

describe 'integration::int-realservicing' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'integration::int-realservicing' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
