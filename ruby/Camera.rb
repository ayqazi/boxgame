class Camera
    def initialize(args)
        args.rekey!
        @world = args.fetch :world
        @target = args.fetch :target
        @canvas = args.fetch :canvas
    end

    def world_draw_offset
        return (-@target.center.to_v + @canvas.surface.dimensions.to_v/2).to_a
    end

    def snap
        @world.draw(@canvas, world_draw_offset)
    end
end
