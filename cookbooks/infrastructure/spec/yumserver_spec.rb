require 'chefspec'

describe 'infrastructure::yumserver' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::yumserver' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
