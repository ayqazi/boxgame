class Rubygame::Surface
  def dimensions
    return [*size]
  end

  def self.create(dimensions)
    surface = Rubygame::Surface.new(dimensions, 32, [Rubygame::SRCALPHA, Rubygame::RLEACCEL])
    surface = surface.to_display_alpha
    return surface
  end
end
