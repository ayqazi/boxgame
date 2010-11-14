require 'spec_setup.rb'

describe StateMachine do

    class StateBase
        def initialize(log, sm)
            @log = log
            @state_machine = sm
        end

        def atentry
            @log << "enter #{getname}|"
        end

        def atexit
            @log << "exit #{getname}|"
        end
    end

    class State1 < StateBase
        def getname
            return "State1"
        end
    end

    class State2 < StateBase
        def getname
            return "State2"
        end
    end

    class State3 < StateBase
        def getname
            return "State3"
        end

        def atentry
            super
            @state_machine.next_state_name = "state4"
        end
    end

    class State4 < StateBase
        def getname
            return "State4"
        end

        def atexit
            super
            @state_machine.next_state_name = "state1"
        end
    end

    before do
        @log = ""
        @sm = StateMachine::new

        @state1 = State1.new @log, @sm
        @state2 = State2.new @log, @sm
        @state3 = State3.new @log, @sm
        @state4 = State4.new @log, @sm

        @sm.add("state1", @state1)
        @sm.add("state2", @state2)
        @sm.add("state3", @state3)
        @sm.add("state4", @state4)
    end

    it 'test1' do
        cmplog = ""

        @sm.current_state.should == nil
        @sm.current_state_name.should == nil
        @sm["state1"].getname.should == "State1"
        @sm["state2"].getname.should == "State2"

        # First trigger! moves from no current state to the asked for next
        # state (i.e. it is the initial state)
        cmplog += "enter State1|"
        @sm.next_state_name = "state1"
        @sm.trigger!
        @sm.current_state.should == @state1
        @sm.current_state_name.should == "state1"
        cmplog.should == @log

        # Next move to state2

        @sm.next_state_name = "state2"

        @sm.trigger! # Change to state2
        cmplog += "exit State1|enter State2|"

        @sm.current_state.should == @state2
        @sm.current_state_name.should == "state2"
        cmplog.should == @log

        # Change to state2 AGAIN
        @sm.next_state_name = "state2"
        @sm.trigger!
        cmplog += "exit State2|enter State2|"

        @sm.current_state.should == @state2
        @sm.current_state_name.should == "state2"
        cmplog.should == @log

        # Change to state3
        @sm.next_state_name = "state3"
        @sm.trigger!
        cmplog += "exit State2|enter State3|"

        @sm.current_state.should == @state3
        @sm.current_state_name.should == "state3"
        @sm.next_state_name.should == "state4"
        cmplog.should == @log

        # Next state automatically set by state3 atentry to state4
        @sm.trigger!
        cmplog += "exit State3|enter State4|"

        @sm.current_state.should == @state4
        @sm.current_state_name.should == "state4"
        @sm.next_state_name.should == nil
        cmplog.should == @log

        # we set and trigger state machine onto state 2 - but state 4's atexit
        # sets next state to state 1 in the process
        @sm.next_state_name = 'state2'
        @sm.trigger!
        cmplog += "exit State4|enter State2|"

        @sm.current_state.should == @state2
        @sm.current_state_name.should == "state2"
        @sm.next_state_name.should == 'state1'
        cmplog.should == @log
    end

    describe 'when setting and transitioning to the initial state' do
        it 'allow just setting the current state to the initial state immediately without having to wait for a trigger' do
            expectedlog = ''

            @sm.initially_already_at('state1')
            @sm.current_state_name.should == 'state1'
            @sm.next_state_name = 'state2'
            @sm.trigger!
            expectedlog += 'exit State1|enter State2|'
            expectedlog.should == @log
        end

        it 'not allow just setting the current state to the initial state immediately if the state machine has already experienced its first transition' do
            @sm.next_state_name = 'state2'
            @sm.trigger!

            lambda { @sm.initially_already_at('state1') }.should raise_error(StateMachine::StartedError)
        end

        it 'only accept valid state names' do
            lambda { @sm.initially_already_at('pants') }.should raise_error(IndexError)
        end

    end

    describe 'switching states immediately' do
        it 'not work initially as no immediate state is set' do
            lambda { @sm.next_state_name_immediately = 'state2' }.should raise_error(StateMachine::NotStartedError)
        end

        it 'work already initially at a state' do
            expectedlog = ''
            @sm.initially_already_at('state1')
            @sm.next_state_name_immediately = 'state2'
            expectedlog += 'exit State1|enter State2|'
            expectedlog.should == @log
        end
    end
end
