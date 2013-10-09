require 'chefspec'

describe 'apache::mod_bw' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'apache::mod_bw' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
