require 'chefspec'

describe 'infrastructure::selinux' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::selinux' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
