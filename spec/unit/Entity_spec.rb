require 'spec_setup.rb'

describe Entity do

    before do
        @container = FakeContainer.new
    end

    it 'should have its container parameter set when added to a container' do
        entity1 = FakeEntity.new(:rect => [0, 0, 20, 20], :container => @container)
        entity1.container.should == @container
        @container.entities.should include(entity1)
    end

    describe  'initialization' do

        it 'set its rect when initialized' do
            entity1 = FakeEntity.new(:rect => [0, 0, 20, 20])
            entity1.rect.should == [0, 0, 20, 20]
        end

        it 'allow container to not exist' do
            entity1 = FakeEntity.new(:rect => [0, 0, 20, 20])
            entity1.collisions.should == []
            entity1.collisions_with_others_of([1,2,3,4]).should == []
        end

        it 'default rect to [0, 0, 0, 0]' do
            entity = FakeEntity.new
            entity.rect.should == [0,0,0,0]
        end

    end

    context 'collision detection' do
        before do
            @fake_container  = FakeContainer.new
            @entity1 = FakeEntity.new(:name => 'e1', :rect => Rect[0, 0, 20, 20], :container => @fake_container )
            @entity2 = FakeEntity.new(:name => 'e2', :rect => Rect[21, 0, 10, 10], :container => @fake_container )
            @entity3 = FakeEntity.new(:name => 'e3', :rect => Rect[0, 21, 10, 10], :container => @fake_container )
        end

        it 'detect collisions between it and any of its containers other entities' do
            @entity1.collisions.collect(&:name).should == []

            @entity2.position = [20, 0]
            @entity1.collisions.collect(&:name).should == [@entity2].collect(&:name)
            @entity2.collisions.collect(&:name).should == [@entity1].collect(&:name)

            @entity3.position = [0, 0]
            @entity1.collisions.collect(&:name).should == [@entity2, @entity3].collect(&:name)
            @entity2.collisions.collect(&:name).should == [@entity1].collect(&:name)
            @entity3.collisions.collect(&:name).should == [@entity1].collect(&:name)
        end

        it 'detect potential collisions between it and any of its container siblings if it was change its rect to that provided' do
            @entity1.collisions_with_others_of(Rect[1, 1, 10, 10]).collect(&:name).should == []
            @entity1.rect.should == [0, 0, 20, 20]

            @entity1.collisions_with_others_of(Rect[10, 10, 12, 12]).collect(&:name).should == ['e2', 'e3']
            @entity1.rect.should == [0, 0, 20, 20]
        end
    end

    it 'get back #center' do
        entity1 = FakeEntity.new(:rect => [0, 0, 9, 9])
        entity1.center.should == [4, 4]
    end

    it('is dimensional') do
        FakeEntity.new(:rect => [0, 0, 10, 10]).should be_dimensional
    end

    # For interacted apon / state machine tests, see ChestTest.rb
end
