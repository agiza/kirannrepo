require 'chefspec'

describe 'apache::mod_security' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'apache::mod_security' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
