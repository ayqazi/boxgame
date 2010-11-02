module Harg
    class Error < ArgumentError; end

    def using_hargs(args)
        init_hargs(args)
        # block.call # Will evaluate block in the context it was defined, not in the context of the object whose method we are defining!
        retval = yield
        fin_hargs
        return retval
    end

    def harg(name)
        return @hargs_[name]
    end

    def harg!(name)
        raise Harg::Error, "#{name.inspect} expected" unless @hargs_.has_key?(name)
        return harg(name)
    end

    def hargs!(*names)
        return names.collect { |name| harg! name }
    end

    private

    def init_hargs(args)
        @hargs_stack_ ||= []

        @hargs_stack_.push(@hargs_)

        @hargs_ = args
    end

    def fin_hargs
        @hargs_ = @hargs_stack_.pop
    end

end
