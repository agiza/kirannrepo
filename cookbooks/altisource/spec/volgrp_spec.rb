require 'chefspec'

describe 'altisource::volgrp' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'altisource::volgrp' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
