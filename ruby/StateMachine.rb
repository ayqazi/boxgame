# See test/statemachine.rb for example usage.
#
# You need to call the atexit method of the final state yourself if you need to
# exit the state machine!
class StateMachine

    class Error < RuntimeError; end

    class StartedError < Error; end
    class NotStartedError < Error; end

    def initialize
	@states = {}
	@current_state_name = nil
	@next_state_name = nil # name of next state
	return self
    end

    def current_state; return @states[@current_state_name]; end

    def current_state_name; @current_state_name; end

    attr_reader :next_state_name

    def next_state_name=(state_name)
	if(state_name == nil)
	    @next_state_name = nil
	else
	    @states.fetch(state_name) # check it exists
	    @next_state_name = state_name
	end
	return @next_state_name
    end

    def [](name); return @states[name]; end

    def fetch(name)
        @states.fetch(name)
    end

    # Add 'state' as a state under key 'name' - raise if name already used!
    # Returns self.
    def add(name, state)
	if(@states[name] != nil)
	    raise StateMachine::Error, "state '#{name}' exists"
	end
	@states[name] = state
	return self
    end

    # If next is not nil, changes to next state specified in 'next='
    # and resets 'next' state to nil.  The old current state has its
    # atexit method called, and the new state has its atentry method
    # called.
    #
    # If next is nil, does nothing
    #
    # Modified so that you MAY call StateMachine#next= during atexit
    # or atentry
    def trigger!
	return if (@next_state_name == nil)

	current_state = nil
        current_state = @states.fetch(@current_state_name) unless @current_state_name.nil?

	next_state = @states.fetch(@next_state_name)
        next_state_name = @next_state_name

	@next_state_name = nil

	current_state.atexit if(current_state.respond_to?(:atexit))
	@current_state_name = next_state_name
	next_state.atentry if(next_state.respond_to?(:atentry))
    end

    def initially_already_at(state_name)
        raise StartedError if @current_state_name != nil
        @states.fetch(state_name) # check it's there
        @current_state_name = state_name
    end

    def next_state_name_immediately=(state_name)
        raise NotStartedError unless @current_state_name
        self.next_state_name = state_name
        self.trigger!
    end

end # class StateMachine
