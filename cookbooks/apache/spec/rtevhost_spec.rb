require 'chefspec'

describe 'apache::rtevhost' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'apache::rtevhost' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
