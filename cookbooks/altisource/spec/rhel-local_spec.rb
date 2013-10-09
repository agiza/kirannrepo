require 'chefspec'

describe 'altisource::rhel-local' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'altisource::rhel-local' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
