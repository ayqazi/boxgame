require 'spec_setup.rb'

describe Chest do

    before do
        @container = FakeContainer.new
        @chest = Chest.new(:container => @container)
        @chest.animation.current_frame_index.should == 0
    end

    describe 'initialization' do
        it 'accepts position' do
            chest = Chest.new(:container => @container, :position => [12, 12])
            chest.position.should == [12, 12]
        end

        it 'gets w/h from img' do
            @chest.w.should == 27
            @chest.h.should == 23
        end
    end

    describe 'when interacted upon' do
        describe 'by Player' do

            before do
                @player = Player.new(:container => @container)
                @chest.is.should == 'closed'
                @chest.interacted_upon_by(@player)
                @chest.update
            end

            it 'switches state from "closed" to "opened"' do
                @chest.is.should == 'open'
            end

            it 'should be opened_by Player' do
                @chest.animation.current_frame_index.should == 1
            end

            it 'should not do anything else once opened' do
                lambda { @chest.interacted_upon_by(@player) }.should_not change{@chest}
            end
        end

        describe 'not by the Player' do
            before do
                @entity = FakeEntity.new(:container => @container)
                @chest.is.should == 'closed'
                @chest.interacted_upon_by(@entity)
                @chest.update
            end

            it 'not switch states' do
                @chest.is.should == 'closed'
            end

            it 'not be opened_by Player' do
                @chest.animation.current_frame_index.should == 0
            end
        end

    end

end
