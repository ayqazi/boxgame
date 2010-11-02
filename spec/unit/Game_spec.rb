require File.dirname(__FILE__) + "/../setup.rb"

context Game do
    it 'raises error when trying to run it uninitialised' do
        Game.initialised?.should == false
        lambda { Game.run }.should raise_error(Game::UninitialisedError)
    end

    it 'should have text attr accessor' do
        Game.instance_variable_set(:@text, [])
        Game.text << 'abc'
        Game.instance_variable_get(:@text).should == ['abc']
    end

end
