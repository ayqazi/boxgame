class Float
    def close_to_zero?
        return(self.abs <= 0.001)
    end
end

class Integer
    alias_method :close_to_zero?, :zero?
end

class Numeric
    def degrade(amount)
        amount = amount.abs

        # e.g. 10.degrade(11)
        return 0 if amount > self.abs

        retval = (self > 0) ? self - amount : self + amount
        if retval.close_to_zero?
            return 0
        else
            return retval
        end
    end

    def limit_distance_from_zero_to(max)
        max = max.abs
        return self if self == 0

        if self > 0
            if self > max
                return max
            else
                return self
            end
        else
            if self < -max
                return -max
            else
                return self
            end
        end
    end
end
