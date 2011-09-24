class Game
  class UninitialisedError < RuntimeError; end

  private_class_method :new

  def self.initialised?; return (@initialised == true); end

  def self.initialise
    init_system
    init_game
    init_state
  end

  def self.init_system
    @screen = Rubygame::Screen.new [1024, 640], 32, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @events = Rubygame::EventQueue.new
    @events.enable_new_style_events
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 25

    Rubygame::TTF.setup
    @ttf = Rubygame::TTF.new((DATADIR + "DejaVuSansMono.ttf").to_s, 12)
  end

  def self.init_world
    @world = World.new
    @player = Player.new(:container => @world)
    @player.position = [1000, 1800]
  end

  def self.init_game
    @text = []
    init_world
    @camera = Camera.new(:world => @world, :target => @player, :canvas => self)
    @fps = EventsPerPeriodTracker.new(:period_length => 0.5)
  end

  def self.init_state
    @initialised = true
    @quit = false
  end

  def self.run
    raise UninitialisedError unless initialised?

    main_loop

    Rubygame.quit
    @initialised = false
  end

  def self.surface; return @screen; end

  def self.text; @text; end

  def self.quit; @quit = true; end

  def self.process_event_queue
    @events.each do |event|
      @player.handle_event(event)
    end
  end

  def self.update; @world.update; end

  def self.draw_text
    @text.each_with_index do |str, idx|
      next if str.nil?
      surface = @ttf.render_utf8(str, true, [0, 0, 0])
      @screen.fill([255, 255,255], [20, 20 + idx*surface.h, surface.w, surface.h])
      surface.blit(@screen, [20, 20 + idx*surface.h])
    end
    @text.clear
  end

  def self.draw
    @fps.event!.update

    @screen.fill([9, 31, 154])

    @camera.snap

    text << "fps: #{@fps.to_s}" << nil

    draw_text

    @screen.flip
  end

  def self.main_loop
    loop do
      break if @quit

      process_event_queue
      update
      draw
      @clock.tick
    end
  end
end
