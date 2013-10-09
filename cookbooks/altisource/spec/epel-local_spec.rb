require 'chefspec'

describe 'altisource::epel-local' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'altisource::epel-local' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
