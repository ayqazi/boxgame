require 'spec_setup.rb'

describe World do

  describe 'adding an entity' do
    it 'set the entities #container attribute to me' do
      world = World.new
      entity = FakeEntity.new
      world.add_entity(entity)
      entity.container.should == world
    end
  end

  describe "#draw" do
    it 'works' do
      stub_surface = stub('stub_surface')
      stub_canvas = stub("stub_canvas", :surface => stub_surface)
      offset = [1, 2]

      @world = World.new

      @world.expects(:draw_entities).with(stub_canvas, offset)
      @world.instance_eval { @bg.expects(:blit).with(stub_surface, offset) }

      @world.draw(stub_canvas, offset)
    end
  end
end
