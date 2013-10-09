require 'chefspec'

describe 'altisource::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'altisource::default' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
