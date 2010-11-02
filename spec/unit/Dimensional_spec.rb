require File.dirname(__FILE__) + "/../setup.rb"

describe Dimensional do
    class TestObj
        include Dimensional
        def dimensions
            [10, 15]
        end
    end

    before do
        @obj = TestObj.new
    end

    describe 'when including obj provides "dimensions"' do

        it('dimensions[0]') { @obj.dimensions[0].should == 10 }
        it('w') { @obj.w.should == 10 }
        it('width') { @obj.width.should == 10 }

        it('dimensions[1]') { @obj.dimensions[1].should == 15 }
        it('h') { @obj.h.should == 15 }
        it('height') { @obj.height.should == 15 }
    end

    describe 'rspec macro' do
        it 'works' do
            obj = Object.new
            class << obj
                def dimensions
                    retval = [0, 1]
                    return retval
                end

                def w; dimensions[0]; end
                def h; dimensions[1]; end
                alias_method(:width, :w)
                alias_method(:height, :h)
            end
            obj.should be_dimensional
        end
    end
end
