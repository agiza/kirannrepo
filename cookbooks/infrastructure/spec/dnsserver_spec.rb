require 'chefspec'

describe 'infrastructure::dnsserver' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'infrastructure::dnsserver' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
