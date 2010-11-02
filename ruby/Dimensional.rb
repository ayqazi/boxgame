module Dimensional
    def w; return dimensions[0]; end
    alias_method :width, :w
    def h; return dimensions[1]; end
    alias_method :height, :h
end
