require 'chefspec'

describe 'integration::int-collateralanalytics' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'integration::int-collateralanalytics' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
