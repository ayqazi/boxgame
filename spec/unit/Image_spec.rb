require File.dirname(__FILE__) + "/../setup.rb"

describe Image do

    describe "initialization" do
        it "work when absolute filename is supplied" do
            img = Image.new(:filename => DATADIR + 'test/8x8_spectrum.tga')
            img.filename.should == DATADIR + 'test/8x8_spectrum.tga'
            img.surface.should be_kind_of(Rubygame::Surface)
        end

        it "work when DATADIR-relative filename is supplied" do
            img = Image.new(:filename => 'test/8x8_spectrum.tga')
            img.filename.should == DATADIR + 'test/8x8_spectrum.tga'
            img.surface.should be_kind_of(Rubygame::Surface)
        end

        it 'use whole surface area as srcrect if no srcrect supplied' do
            img = Image.new(:filename => 'test/8x8_spectrum.tga')
            img.srcrect.should == Rect[0, 0, 8, 8]
        end

        it 'use given srcrect if supplied' do
            img = Image.new(:filename => 'test/8x8_spectrum.tga', :srcrect => Rect[2, 2, 4, 4])
            img.srcrect.should == Rect[2, 2, 4, 4]
            img = Image.new(:filename => 'test/8x8_spectrum.tga', :srcrect => [0, 0, 4, 4])
            img.srcrect.should == Rect[0, 0, 4, 4]
        end

        describe 'from another Image' do

            before do
                @img_orig = Image.new(:filename => DATADIR + 'test/8x8_spectrum.tga')
            end

            it 'get a complete duplicate' do
                img = @img_orig.new_partial
                img.filename.should == DATADIR + 'test/8x8_spectrum.tga'
                img.surface.should == @img_orig.surface
                img.srcrect.should == @img_orig.srcrect
            end

            it 'get complete duplicate, with supplied srcrect as specified' do
                img = @img_orig.new_partial(:srcrect => [2, 2, 4, 4])
                img.filename.should == DATADIR + 'test/8x8_spectrum.tga'
                img.surface.should == @img_orig.surface
                img.srcrect.should == Rect[2, 2, 4, 4]
            end

        end

    end

    describe 'blitting' do
        it 'use srcrect if it was supplied' do
            img = Image.new(:filename => 'test/8x8_spectrum.tga', :srcrect => [2, 2, 4, 4])
            fake_surface = stub('fake_surface')
            fake_canvas = mock('fake_canvas', :surface => fake_surface)
            img.surface.expects(:blit).with(fake_surface, [0, 0], [2, 2, 4, 4])
            img.draw(fake_canvas, [0, 0])
        end

        it 'use whole image if srcrect was not supplied' do
            img = Image.new(:filename => 'test/8x8_spectrum.tga')
            fake_surface = stub('fake_surface')
            fake_canvas = mock('fake_canvas', :surface => fake_surface)
            img.surface.expects(:blit).with(fake_surface, [0, 0], [0, 0, 8, 8])
            img.draw(fake_canvas, [0, 0])
        end
    end

    describe 'getting width/height in response to w/h/width/height/dimensions' do
        it 'work when no srcrect specified' do
            img = Image.new(:filename => 'test/8x8_spectrum.tga')
            img.w.should == img.surface.w
            img.h.should == img.surface.h
            img.width.should == img.surface.width
            img.height.should == img.surface.height
            img.dimensions.should == img.surface.dimensions
        end

        it 'work when srcrect specified' do
            img = Image.new(:filename => 'test/8x8_spectrum.tga', :srcrect => [2, 2, 4, 5])
            img.w.should == 4
            img.h.should == 5
            img.width.should == 4
            img.height.should == 5
        end
    end

end
