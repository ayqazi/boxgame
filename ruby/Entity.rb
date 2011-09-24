require 'forwardable'

module Entity
  extend Forwardable

  attr_reader :container
  attr_reader :name

  private
  attr_writer :container

  public

  hargdef :init_entity do
    container = harg :container
    @name = harg :name
    container.add_entity(self) if container

    if harg :rect
      @rect = Rect.new(harg :rect)
    else
      @rect = Rect[0, 0, 0, 0]
    end
  end

  def rect; return @rect.clone; end

  def position
    return [@rect[0], @rect[1]]
  end

  def position=(ary)
    @rect[0] = ary[0].to_f
    @rect[1] = ary[1].to_f
    return position
  end

  def center
    return [*@rect.center]
  end

  def dimensions=(args)
    @rect.dimensions = args
  end

  include Dimensional
  def dimensions; @rect.dimensions; end

  def update; end

  def collisions_with_others_of(newrect)
    return [] unless self.container

    collides_with = []
    self.container.entities.each do |other|
      next if other == self
      if newrect.collide_rect?(other.rect)
        collides_with << other
      end
    end

    return collides_with
  end

  def collisions
    return collisions_with_others_of(self.rect)
  end

  class State
    def initialize(entity); @entity = entity; end

    def interacted_upon_by(who)
      @interacted_upon_by_proc.call(who) if @interacted_upon_by_proc
    end

    def when_interacted_upon(&block)
      @interacted_upon_by_proc = block
    end
  end

  def_delegator :@state_machine, :current_state_name, :is
  def_delegator :@state_machine, :next_state_name, :will_be

  def_delegators :current_state, :interacted_upon_by

  private

  def_delegators :@state_machine, :current_state

  hargdef :init_state_machine do
    states, initial_state = hargs! :states, :initial_state

    @state_machine = StateMachine.new
    states.each do |state|
      @state_machine.add state, State.new(self)
    end

    @state_machine.initially_already_at initial_state
  end

end
