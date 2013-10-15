require 'chefspec'

describe 'infrastructure::openldap' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::openldap' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
