require 'chefspec'

describe 'infrastructure::realsvckey' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::realsvckey' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
