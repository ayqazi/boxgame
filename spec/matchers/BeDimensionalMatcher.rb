module BeDimensionalMatcher
    class BeDimensional

        def matches?(target)
            @target = target
            @error_messages = []

            unless @target.respond_to?(:dimensions)
                @error_messages << 'should respond to :dimensions'
                return false
            end

            @dimensions = @target.dimensions

            unless @dimensions.respond_to?(:[])
                @error_messages << '#dimensions should respond to :[]'
                return false
            end

            if(@dimensions[0] == nil or @dimensions[1] == nil)
                @error_messages << '#dimensions[0] and #dimensions[1] should not be nil'
                return false
            end

            [:w, :h, :width, :height].each do |required_attr|
                unless @target.respond_to?(required_attr)
                    @error_messages << "should respond to #{required_attr.inspect}"
                end
            end
            return false unless @error_messages.empty?

            unless(@target.w == @dimensions[0])
                @error_messages << '#w should == #dimensions[0]'
            end

            unless(@target.h == @dimensions[1])
                @error_messages << '#h should == #dimensions[1]'
            end

            unless(@target.width == @dimensions[0])
                @error_messages << '#width should == #dimensions[0]'
            end

            unless(@target.height == @dimensions[1])
                @error_messages << '#height should == #dimensions[1]'
            end

            return @error_messages.empty?
        end

        def failure_message
            "expected <#{@target.inspect}> to be dimensional\nUnmatched conditions:\n#{@error_messages.join("\n")}"
        end

        def negative_failure_message
            "expected <#{@target.inspect}> not to be dimenisonal"
        end
    end

    # Actual matcher that is exposed.
    def be_dimensional
        BeDimensional.new
    end
end
