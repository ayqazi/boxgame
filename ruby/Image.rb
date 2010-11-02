class Image

    class MissingArgument < ArgumentError; end

    hargdef :initialize do
	@srcrect = harg :srcrect
	@filename = Pathname.new(harg! :filename)
        @filename = DATADIR + @filename if @filename.relative?
        @surface = Rubygame::Surface.load(@filename.to_s)
        init_rect
    end

    attr_reader(:surface, :filename)
    attr_accessor :srcrect

    def draw(canvas, offset)
        @surface.blit(canvas.surface, offset, @srcrect)
    end

    hargdef :new_partial do
        retval = self.clone
        new_srcrect = harg :srcrect
        if new_srcrect
            retval.srcrect = Rect.new(new_srcrect)
        end
        next retval
    end

    def dimensions; return @srcrect.dimensions; end
    include Dimensional

private

    def init_rect
        if @srcrect
            @srcrect = Rect.new(@srcrect) # Convert to Rect, whatever it is
        else
            @srcrect = @surface.make_rect # Get from image
        end
    end


end
