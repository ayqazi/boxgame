class Chest

    include Entity

    hargdef :initialize do
        # we only use position, not rect
        init_entity(:container => harg(:container))
        self.position = harg :position if harg :position

        init_state_machine(:states => ['open', 'closed'], :initial_state => 'closed')

        @state_machine['closed'].when_interacted_upon do |who|
            self.opened_by(who)
        end

        @animation = Animation.new(:image => 'treasure_chest.png', :frames_across => 2, :frames_down => 1)

        # copy dimensions from @animation
        self.dimensions = @animation.dimensions
    end

    attr_reader :animation

    def draw(canvas, offset)
        @animation.draw(canvas, @rect.offset(offset))
    end

    def update
        @state_machine.trigger!
    end

    def opened_by(who)
        return unless who.kind_of?(Player)
        @state_machine.next_state_name = 'open'
        @animation.current_frame_index = 1
    end

end
