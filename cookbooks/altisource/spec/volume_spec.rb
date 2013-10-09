require 'chefspec'

describe 'altisource::volume' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'altisource::volume' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
