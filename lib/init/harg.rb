class Object
    include Harg
end

class Module

    def hargdef(methodname, &block)
        define_method(methodname) do |*args|
            using_hargs(args.last || {}) do
                # block.call # Will evaluate block in the context it was defined, not in the context of the object whose method we are defining!
                self.instance_eval(&block)
            end
        end
    end

end
