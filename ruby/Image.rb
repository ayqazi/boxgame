class Image

  class MissingArgument < ArgumentError; end

  def initialize(args)
    args.rekey!
    @srcrect = args[:srcrect]

    @filename = Pathname.new(args.fetch :filename)
    if @filename.relative?
      @filename = DATADIR + @filename
    end

    @surface = Rubygame::Surface.load(@filename.to_s)

    init_rect
  end

  attr_reader(:surface, :filename)
  attr_accessor :srcrect

  def draw(canvas, offset)
    @surface.blit(canvas.surface, offset, @srcrect)
  end

  def new_partial(args = {})
    args.rekey!
    retval = self.clone

    if args[:srcrect]
      retval.srcrect = Rect.new(args[:srcrect])
    end

    return retval
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
