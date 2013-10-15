require 'chefspec'

describe 'infrastructure::dns' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::dns' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
