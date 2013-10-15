require 'chefspec'

describe 'infrastructure::cntlmd' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::cntlmd' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
