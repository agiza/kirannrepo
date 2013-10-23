require 'chefspec'

describe 'atlassian::atlasmount' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'atlassian::atlasmount' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
