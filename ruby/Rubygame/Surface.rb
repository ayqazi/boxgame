class Rubygame::Surface
    def dimensions
        return [*size]
    end

    def self.create(dimensions)
        surface = Rubygame::Surface.new(dimensions, 32, [Rubygame::SRCALPHA, Rubygame::RLEACCEL])
        surface = surface.to_display_alpha || surface # so tests can stub out to_display_alpha and this will still work
        return surface
    end
end
