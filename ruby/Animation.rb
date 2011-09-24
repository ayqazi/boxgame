require 'forwardable'

class Animation
    # Note: only supports frames laid out in horizontally in an image from left to
    # right - first frame starts at 0

    # xrects = 'Extra Rects'; bad identifier name :-(
    class Frame
        def initialize(args)
            args.rekey!
            @image = args.fetch :image
            @xrects = args.fetch :xrects
        end

        attr_reader :image

        extend Forwardable
        def_delegators :@image, :w, :h, :width, :height, :dimensions, :draw

        def xrect(idx); @xrects.fetch idx; end
    end

    class Bug < StandardError; end

    def initialize(args)
        args.rekey!

        init_frames(args)
        self.current_frame_index = 0
        @current_frame = @frames[0]
    end

    attr_reader :current_frame_index, :current_frame

    def count; return @frames.size; end

    def current_frame_index=(idx)
        @current_frame_index = idx
        @current_frame = @frames.fetch(idx)
    end

    def [](idx); return @frames[idx]; end

    def each(&block); @frames.each(&block); end
    include Enumerable

    def draw(canvas, offset)
        @current_frame.draw(canvas, offset)
    end

    def dimensions; @current_frame.dimensions; end
    include Dimensional

    private

    def init_frames(args)
        xrects = args[:xrects] || []

        frame_images = construct_frame_images(args)

        @frames = construct_frames(:xrects => xrects, :frame_images => frame_images)

        if @frames.size != count
            raise Bug, "Generated frames: #{@frames.size}; requested number of frames: #{count}"
        end
    end

    def construct_frame_images(args)
        image = get_image(args.fetch(:image))
        frame_images = []
        frames_across, frames_down = args.fetch(:frames_across), args.fetch(:frames_down)
        frame_width = image.w/frames_across
        frame_height = image.h/frames_down

        (0...frames_down).each do |frame_down|
            (0...frames_across).each do |frame_across|
                frame_images << image.new_partial(:srcrect => Rect[frame_across*frame_width, frame_down*frame_height, frame_width, frame_height])
            end
        end

        return frame_images
    end

    def get_image(image)
        image = Image.new(:filename => image) if image.respond_to?(:to_str)
        return image
    end

    def construct_frames(args)
        frames = []
        xrects, frame_images = args.values_at :xrects, :frame_images
        xrects.pad!(frame_images.size, {})
        xrects.zip(frame_images).each do |frame_xrects, frame_image|
            frame_xrects.if_not_nil.each_pair { |tag, rect| frame_xrects[tag] = Rect.new(rect) }
            frames << Frame.new(:image => frame_image, :xrects => frame_xrects)
        end

        return frames
    end
end
