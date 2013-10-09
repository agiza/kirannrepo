require 'chefspec'

describe 'apache::l1vhost' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'apache::l1vhost' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
