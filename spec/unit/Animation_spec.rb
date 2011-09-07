require 'spec_setup.rb'

describe Animation do

    SOURCE_IMAGE = Image.new(:filename => 'test/jacko.png')
    VALID_ARGS = {
        :image => SOURCE_IMAGE,
        :frames_across => 3,
        :frames_down => 4
    }.clone

    let(:animation) { Animation.new(VALID_ARGS) }

    describe 'when width%frames_across and height%frames_down both equal 0' do
        it 'calculates frame width' do
            animation.current_frame.w.should == 32
        end

        it 'calculates frame height' do
            animation.current_frame.h.should == 48
        end

        it 'calculates frame count' do
            animation.count.should == 12
        end

        it 'works when frames_across is 1' do
            animation2 = Animation.new(VALID_ARGS.merge(:frames_across => 1))
            animation2.current_frame.w.should == 96
            animation2.current_frame.h.should == 48
            animation2.count.should == 4
        end

        it 'works when frames_down is 1' do
            animation2 = Animation.new(VALID_ARGS.merge(:frames_down => 1))
            animation2.current_frame.w.should == 32
            animation2.current_frame.h.should == 48*4
            animation2.count.should == 3
        end

        it 'initializes srcrects properly' do
            animation[0].image.srcrect.should == Rect[0, 0, 32, 48]
            animation[4].image.srcrect.should == Rect[32, 48, 32, 48]
            animation[7].image.srcrect.should == Rect[32, 96, 32, 48]
        end
    end

    it 'initializes properly if :image is a filename instead of an Image' do
        animation = Animation.new(VALID_ARGS.merge(:image => SOURCE_IMAGE.filename))
        animation.current_frame.w.should == 32
        animation.current_frame.h.should == 48
        animation.count.should == 12
    end

    it 'lets current frame be set' do
        animation.current_frame.image.srcrect.should == [0, 0, 32 ,48]
        animation.current_frame_index.should == 0
        animation.current_frame_index = 2
        animation.current_frame.image.srcrect.should == [64, 0, 32, 48]
        animation.current_frame_index.should == 2
        animation.current_frame_index = 7
        animation.current_frame.image.srcrect.should == [32, 96, 32, 48]
        animation.current_frame_index.should == 7
    end

    describe '#[]' do
        it 'give back correct frame' do
            animation[0].image.srcrect.x.should == 0
            animation[0].image.srcrect.y.should == 0
            animation[6].image.srcrect.x.should == 0
            animation[6].image.srcrect.y.should == 96
            animation[11].image.srcrect.x.should == 64
            animation[11].image.srcrect.y.should == 144
        end
    end

    it 'draws current frame' do
        canvas, offset = stub('canvas'), stub('offset')
        animation.current_frame.expects(:draw).with(canvas, offset)
        animation.draw(canvas, offset)
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
