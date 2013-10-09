require 'chefspec'

describe 'apache::rfvhost' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'apache::rfvhost' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
