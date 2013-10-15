require 'chefspec'

describe 'infrastructure::chefclient' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::chefclient' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
