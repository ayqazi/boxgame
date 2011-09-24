require 'rubygame'

class Rubygame::Rect

  def get_other_coords(args)
    if args[0].kind_of?(Array) or args[0].kind_of?(Vector)
      return args[0]
    else
      return args
    end
  end

  def offset(*args)
    other = get_other_coords(args)

    return Rubygame::Rect.new(self[0] + other[0], self[1] + other[1], self[2], self[3])
  end

  def offset!(*args)
    other = get_other_coords(args)

    self[0] += other[0]
    self[1] += other[1]

    return self
  end

  def degrade!(amount)
    self[0] = self[0].degrade(amount)
    self[1] = self[1].degrade(amount)
  end

  def dimensions=(args)
    self[2], self[3] = args.fetch(0), args.fetch(1)
  end

  def dimensions
    return [self[2], self[3]]
  end

  def position
    return [self[0], self[1]]
  end

  def position=(args)
    self[0], self[1] = args.fetch(0), args.fetch(1)
  end
end
