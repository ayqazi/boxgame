class Player

    include Entity

    def load_assets
        xrects = [
            {:interact => [16, 0, 5, 24]},
            {:interact => [16, 0, 5, 24]},
            {:interact => [16, 0, 5, 24]},

            {:interact => [-5, 0, 5, 24]},
            {:interact => [-5, 0, 5, 24]},
            {:interact => [-5, 0, 5, 24]},

            {:interact => [0, -5, 16, 5]},
            {:interact => [0, -5, 16, 5]},
            {:interact => [0, -5, 16, 5]},

            {:interact => [0, 24, 16, 5]},
            {:interact => [0, 24, 16, 5]},
            {:interact => [0, 24, 16, 5]},
        ]
        @animation = Animation.new(:image => 'dude_frames.png', :frames_count => 12, :xrects => xrects)
    end

    def define_variables
        @animation.current_frame_index = 11
        @facing_direction = :down

        @rect.dimensions = [16, 24]

        @velocity = Vector[0, 0]

        @drag = 1

        @max_velocity_magnitude = 1

        # The force to be applied to the actor next update
        @prod_direction = Vector[0, 0]
        @prod_magnitude = 1
        @keys_being_pressed = []

        self.movement_mode = :normal
    end

    hargdef :initialize do
        init_entity :container => harg(:container)

        load_assets
        define_variables
    end

    def draw(canvas, offset)
        @animation.draw(canvas, @rect.offset(offset))
        draw_interact_region(canvas, offset)
    end

    def draw_interact_region(canvas, offset)
        # canvas.surface.fill([0, 24, 96], @animation.current_frame.xrect(:interact).offset(@rect).offset(offset))
        s = Rubygame::Surface.create(@animation.current_frame.xrect(:interact).dimensions)
        s.fill([0, 24, 96, 96])
        s.blit(canvas.surface, @animation.current_frame.xrect(:interact).offset(@rect).offset(offset))
    end

    def handle_event(event)

        case event

        when Rubygame::Events::KeyPressed
            handle_key(event.key, true)

        when Rubygame::Events::KeyReleased
            handle_key(event.key, false)

        end

    end

    PROD_DIRECTIONS = {
        :right => Vector[+1, 0],
        :left => Vector[-1, 0],
        :up => Vector[0, -1],
        :down => Vector[0, +1],
    }

    def handle_key(key, pressed)
        logger.debug("handle_key: #{key} #{if pressed then 'pressed' else 'released' end}")
        if PROD_DIRECTIONS.has_key?(key)
            if pressed
                @keys_being_pressed.push(key)
                @prod_direction += PROD_DIRECTIONS[key]
            else
                @keys_being_pressed.delete(key)
                @prod_direction -= PROD_DIRECTIONS[key]
            end

            unless @keys_being_pressed.empty?
                # see diary entry for 2009-04-12
                change_facing(@keys_being_pressed[-2] || @keys_being_pressed[-1])
            end

            return # key cannot be anything else outside here
        end

        if pressed

            case(key)

            when :q, :escape
                Game.quit

            when :space
                interact

            end
        end
    end

    FACING_FRAMES = {:up => 8, :down => 11, :left => 5, :right => 2}
    def change_facing(new_facing)
        @animation.current_frame_index = FACING_FRAMES.fetch(new_facing)
        @facing_direction = new_facing
    end

    def prod_force; @prod_direction * @prod_magnitude; end

    def attempt_move(new_position)
        newrect = @rect.clone
        newrect.position = new_position
        retval = nil
        if collisions_with_others_of(newrect).empty?
            @rect = newrect
            retval = true
        else
            retval = false
        end

        return retval
    end

    def move
        @velocity += prod_force

        # Apply drag along an axis, but only if a prod is not being applied in
        # that direction already
        @velocity[0] = @velocity[0].degrade(@drag) if @prod_direction[0] == 0
        @velocity[1] = @velocity[1].degrade(@drag) if @prod_direction[1] == 0

        # Simulate terminal velocity by limiting velocity (TODO: calculate
        # movement drag properly so that it increases with velocity until it
        # eventually equals it
        @velocity = @velocity.limit_distance_from_zero_to(@max_velocity_magnitude)

        # @rect.offset! @velocity

        #until self.attempt_move @rect.offset(@velocity)
        #    @velocity *= 0.5
        #end

        # Do nothing if already colliding
        if collisions.empty?

            # Apply velocity to position along axes separately; that way, we will
            # not be stopped completely if we hit a wall on one side.
            velocity_x = Vector[@velocity[0], 0]
            velocity_y = Vector[0, @velocity[1]]

            until self.attempt_move @rect.offset(velocity_x)
                velocity_x *= 0.5
            end

            until self.attempt_move @rect.offset(velocity_y)
                velocity_y *= 0.5
            end

            @velocity[0] = velocity_x[0]
            @velocity[1] = velocity_y[1]
        end

        # self.position = self.position.collect {|i| i.to_i} # clamp to nearest pixel
    end

    def update
        move

        Game.text << "Player: velocity=#{"[%.2f, %.2f]" % @velocity.to_a}, prod_force=#{prod_force.to_a.inspect}, rect=#{position.to_a.inspect}" if Game.initialised?
    end

    MOVEMENT_MODES = {
        #                 drag, max_velocity_magnitude, prod_magnitude
        :normal    => [    2.5,                    5.0,            2.0 ],
        :ice       => [   0.15,                    5.0,            0.3 ],
    }.freeze

    def movement_mode=(modename)
        @drag, @max_velocity_magnitude, @prod_magnitude = MOVEMENT_MODES.fetch(modename)
    end

    def interact
        interact_rect = @animation.current_frame.xrect :interact
        puts "interact_rect: #{interact_rect}"  if $debug
        puts "interact_rect.offset(@rect): #{interact_rect.offset(@rect)}" if $debug
        others = self.collisions_with_others_of(interact_rect.offset(@rect))
        others[0].interacted_upon_by(self) if others[0]
    end

end
