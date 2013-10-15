require 'chefspec'

describe 'infrastructure::ftpserver' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::ftpserver' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
