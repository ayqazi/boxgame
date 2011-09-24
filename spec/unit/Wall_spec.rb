require 'spec_setup.rb'

describe Wall do

  it '#initialize' do
    container = FakeContainer.new
    container.add_entity(wall = Wall.new(:rect => [0, 0, 10, 10]))
    wall.rect.should == [0, 0, 10, 10]
  end

end
