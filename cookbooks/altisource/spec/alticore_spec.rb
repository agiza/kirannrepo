require 'chefspec'

describe 'altisource::alticore' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'altisource::alticore' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
