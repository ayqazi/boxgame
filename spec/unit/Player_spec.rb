require 'spec_setup.rb'

context Player do

    it '#rect is Rect containing position and width/height of frames, #position only has positional coordinates' do
        player = Player.new
        player.position.should == [0, 0]
        player.position = [4, 4]
        player.rect.should == [4, 4, 32, 48]
        player.center.should == [20, 28]
    end

    it 'not allow move if colliding with a container-sibling' do
        container = FakeContainer.new
        player = Player.new(:container => container)
        player.position = [21, 21]
        entity = FakeEntity.new(:rect => Rect[10, 10, 10, 10], :container => container)

        player.attempt_move([20, 20]).should == false
        player.position.should == [21, 21]

        player.attempt_move([25, 25]).should == true
        player.position.should == [25, 25]
    end

    context 'interacting with another entity if that entity collides with one of its "interact" frame xrects' do
        before(:each) do
            @container = FakeContainer.new
            @player = Player.new(:container => @container)
            @chest = Chest.new(:position => [3000, 3000], :container => @container)
        end

        it 'should not interact when facing down' do
            @chest.expects(:opened_by).with(@player).never
            @player.position = [3000, 3000-@player.h-5-1] # 1px gap between xrect and chest
            @player.interact
        end

        it 'should interact when facing down' do
            @chest.expects(:opened_by).with(@player)
            @player.position = [3000, 3000-@player.h-5]
            @player.interact
        end

    end

    it 'should not interact with any entities if none are in its "interact" xrects' do
        container = FakeContainer.new
        player = Player.new(:container => container)
        player.position = [3000, 3000]
        chest = Chest.new(:container => container)
        chest.position = [3000, 3000+player.h+5+1] # Right underneath player's bottom xrect
        chest.is.should == 'closed'
        player.interact
        chest.update
        chest.is.should == 'closed'
    end
end
