module Container
    def init_container
        @entities = []
    end

    def add_entity(entity)
        entity.__send__(:container=, self) # only we can do this!
        @entities << entity
    end

    def draw_entities(canvas, offset)
        offset = offset.clone
        @entities.each do |entity|
            entity.draw(canvas, offset)
        end
    end

    def entities
        return @entities.clone
    end

    def update
        @entities.each { |entity| entity.update }
    end
end
