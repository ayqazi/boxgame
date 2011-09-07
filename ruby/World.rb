class World

    include Container

    def load_assets
        @bg = Rubygame::Surface.load((DATADIR + "land.png").to_s).zoom(4, true)
    end

    def create_entities
        # center block thing
        self.add_entity Wall.new(:rect => [1350, 1550, 1200, 800])

        # walls
        self.add_entity Wall.new(:rect => [850, 800, 100, 3500]) # left
        self.add_entity Wall.new(:rect => [500, 800, 3500, 100]) # top
        self.add_entity Wall.new(:rect => [3300, 800, 100, 3500]) # right
        self.add_entity Wall.new(:rect => [500, 3000, 3500, 100]) # bottom

        # chests
        self.add_entity Chest.new(:position => [1000, 2000])
        self.add_entity Chest.new(:position => [3000, 2000])
        self.add_entity Chest.new(:position => [1500, 1000])
    end

    def initialize
        load_assets
        init_container
        create_entities
    end

    def draw(canvas, offset)
        @bg.blit(canvas.surface, offset)
        draw_entities(canvas, offset)
    end

end
