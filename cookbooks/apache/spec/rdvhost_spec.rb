require 'chefspec'

describe 'apache::rdvhost' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'apache::rdvhost' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
