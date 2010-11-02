class Camera
    hargdef :initialize do
        @world = harg! :world
        @target = harg! :target
        @canvas = harg! :canvas
    end

    def world_draw_offset
        return (-@target.center.to_v + @canvas.surface.dimensions.to_v/2).to_a
    end

    def snap
        @world.draw(@canvas, world_draw_offset)
    end
end
