require 'chefspec'

describe 'altisource::cloudmount' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'altisource::cloudmount' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
