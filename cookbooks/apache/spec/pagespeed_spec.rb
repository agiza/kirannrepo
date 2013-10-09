require 'chefspec'

describe 'apache::pagespeed' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'apache::pagespeed' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
