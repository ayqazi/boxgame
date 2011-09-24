require 'spec_setup.rb'

describe Container do
  before do
    @container = FakeContainer.new
    @entity1 = FakeEntity.new
    @entity2 = FakeEntity.new

    @container.add_entity(@entity1)
    @container.add_entity(@entity2)
  end

  it 'returns entity added with #add_entity from #entities' do
    @container.entities.should == [@entity1, @entity2]
  end

  it 'has #draw_entities' do
    canvas, offset = mock('canvas'), mock('offset')
    offset.stubs(:clone).returns(offset)

    @entity1.expects(:draw).with(canvas, offset)
    @entity2.expects(:draw).with(canvas, offset)

    @container.draw_entities(canvas, offset)
  end

  it 'has #update_entities' do
    @entity1.expects(:update)
    @entity2.expects(:update)

    @container.update
  end
end
