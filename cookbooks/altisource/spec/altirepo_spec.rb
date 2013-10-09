require 'chefspec'

describe 'altisource::altirepo' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'altisource::altirepo' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
