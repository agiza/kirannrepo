require 'chefspec'

describe 'atlassian::fisheye' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'atlassian::fisheye' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
