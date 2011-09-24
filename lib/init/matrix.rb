require 'matrix'

class Vector
  def degrade(amount)
    self.collect { |i| i.degrade(amount) }
  end

  def limit_distance_from_zero_to(amount)
    self.collect { |i| i.limit_distance_from_zero_to(amount) }
  end

  def []=(idx, value)
    raise RangeError, "Element #{idx} does not exist (max #{size-1})" if idx > size-1
    @elements[idx] = value
  end

  def collect!(&block)
    @elements.collect!(&block)
    return self
  end

  def -@
    return collect { |i| -i }
  end

  def /(scalar)
    return collect { |i| i/scalar }
  end
end
