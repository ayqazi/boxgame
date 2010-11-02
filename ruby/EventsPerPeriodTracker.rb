class EventsPerPeriodTracker

    def initialize(args = {}, &block)
        using_hargs(args) do
            @period_length = harg! :period_length
        end

        @period_elapsed_callback = block
        @events = 0
        @events_in_last_period = 0.0
        @period_start_time = 0.0

        # Only for use by elapsed_since_start, nobody else may use it
        @start_time = Time.now
    end

    def to_s
        return "%.1f" % (self.to_f)
    end

    def to_f
        return @events_in_last_period
    end

    def event!
        @events += 1
        return self
    end

    def elapsed_since_start
        Time.now - @start_time
    end

    def update
        # store it so we do not re-calculate it if calling method several times
        now = elapsed_since_start

        if now >= @period_start_time + @period_length
            # We have gone over a period boundary
            time_elapsed_since_period_started = now - @period_start_time
            @events_in_last_period = @events.to_f / time_elapsed_since_period_started
            @period_elapsed_callback.call(self) if @period_elapsed_callback

            # start new period
            @period_start_time = now
            @events = 0
        end
    end

end
