require 'chefspec'

describe 'apache::mod_limitipconn' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'apache::mod_limitipconn' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
