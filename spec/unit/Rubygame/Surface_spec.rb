require 'spec_setup.rb'

describe Rubygame::Surface do

  it('should be dimensional') {Rubygame::Surface.new([20, 20], 32).should be_dimensional}

  it '#dimensions give back size as a Vector' do
    s = Rubygame::Surface.new([20, 20], 32)
    s.dimensions.should == [20, 20]
  end
end
