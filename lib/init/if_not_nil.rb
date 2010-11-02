class Object

    def if_not_nil
        return self
    end

end

class NilClass
    def if_not_nil
        o = Object.new

        class << o
            def method_missing(sym, *args)
                # ignore everything
            end
        end

        return o
    end
end
