class Wall
  include Entity

  def initialize(args)
    init_entity(args)

    @surface = Rubygame::Surface.create(@rect.dimensions)
    @surface.fill([255, 64, 64, 64])
  end

  def draw(canvas, offset)
    @surface.blit(canvas.surface, @rect.offset(offset))
  end
end
