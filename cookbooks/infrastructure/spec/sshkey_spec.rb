require 'chefspec'

describe 'infrastructure::sshkey' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::sshkey' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
