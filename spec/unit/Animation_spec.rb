require 'spec_setup.rb'

describe Animation do

    DUDE_IMAGE = Image.new(:filename => 'dude_frames.png')
    VALID_ARGS = {
        :image => DUDE_IMAGE,
        :frames_count => 12,
    }.clone

    before do
        @animation = Animation.new(VALID_ARGS)
    end

    it 'initialize properly using specified Image and frames_count' do
        @animation.current_frame.w.should == 16
        @animation.current_frame.h.should == 24
        @animation.count.should == 12

        animation2 = Animation.new(VALID_ARGS.merge(:frames_count => 6))
        animation2.current_frame.w.should == 32
        animation2.current_frame.h.should == 24
        animation2.count.should == 6
    end

    it 'initialize properly if :image is a filename instead of an Image' do
        animation = Animation.new(:image => 'dude_frames.png', :frames_count => 12)
        animation.current_frame.w.should == 16
        animation.current_frame.h.should == 24
        animation.count.should == 12
    end

    it 'let current frame be set' do
        @animation.current_frame.image.srcrect.should == [0, 0, 16 ,24]
        @animation.current_frame_index.should == 0
        @animation.current_frame_index = 2
        @animation.current_frame.image.srcrect.should == [32, 0, 16 ,24]
        @animation.current_frame_index.should == 2
        @animation.current_frame_index = 4
        @animation.current_frame.image.srcrect.should == [64, 0, 16 ,24]
        @animation.current_frame_index.should == 4
    end

    it 'initialize srcrects properly' do
        @animation.collect { |i| i.image.srcrect.x }. should == (0..191).step(16).to_a
        animation2 = Animation.new(VALID_ARGS.merge(:frames_count => 6))
        animation2.collect { |i| i.image.srcrect.x }. should == (0..191).step(32).to_a
    end

    describe '#[]' do
        it 'give back correct frame' do
            @animation[0].image.srcrect.x.should == 0
            @animation[1].image.srcrect.x.should == 16
            @animation[2].image.srcrect.x.should == 32
        end
    end

    it 'draw current frame' do
        canvas, offset = stub('canvas'), stub('offset')
        @animation.current_frame.expects(:draw).with(canvas, offset)
        @animation.draw(canvas, offset)
    end

    it('should be dimensional') {Animation.new(VALID_ARGS).should be_dimensional}

    describe 'each Frames xrects' do

        it 'are definable' do
            xrect_definition = [
                { :interact => [0, 0, 1, 24] },
            ]
            valid_args = VALID_ARGS.merge(:xrects => xrect_definition)
            animation = Animation.new(valid_args)

            animation[0].xrect(:interact).should == Rect[0, 0, 1, 24]
            animation[0].xrect(:interact).should be_kind_of(Rect)
        end

    end

end
