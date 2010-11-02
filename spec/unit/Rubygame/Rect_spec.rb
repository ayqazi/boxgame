require File.dirname(__FILE__) + "/../../setup.rb"

describe Rubygame::Rect do

    describe '::[]' do
        it 'work' do
            a = Rubygame::Rect[1,2,3,4]
            a.should == Rubygame::Rect.new(1,2,3,4)
        end
    end

    it '#offset x and y as specified and not affect itself' do
        a = Rubygame::Rect.new(0, 0, 5, 6)
        b = a.offset([1, 2])
        a.should == [0, 0, 5, 6]
        b.should == [1, 2, 5, 6]

        b = a.offset(Vector[1, 2])
        a.should == [0, 0, 5, 6]
        b.should == [1, 2, 5, 6]

        b = a.offset(-1, 1)
        a.should == [0, 0, 5, 6]
        b.should == [-1, 1, 5, 6]
    end

    it '#offset! x and y as specified and affect itself' do
        a = Rubygame::Rect.new(0, 0, 5, 6)
        ret = a.offset!([1, 2])
        a.should == [1, 2, 5, 6]
        ret.should == a

        ret = a.offset!(-1, 1)
        a.should == [0, 3, 5, 6]
        ret.should == a
    end

    describe 'degrade!' do
        it 'degrade x and y with the argument supplied' do
            a = Rubygame::Rect.new(10, 10, 0, 0)
            a.degrade!(0.1)
            a.should == [9.9, 9.9, 0, 0]
        end
    end

    it('is dimensional') do
        rect = Rubygame::Rect.new(10, 10, 5, 5)
        rect.should be_dimensional
    end

    describe 'dimensions' do
        before do
            @rect = Rubygame::Rect.new(10, 10, 5, 5)
        end
        it 'return the correct dimensions' do
            @rect.dimensions.should == [5, 5]
        end

        it 'assign dimensions to indices 2 and 3 of self' do
            @rect.dimensions = [20, 20]
            @rect.should == [10, 10, 20, 20]
        end
    end

    describe 'position' do
        before do
            @rect = Rubygame::Rect[10, 10, 20, 20]
        end
        it 'return correct value' do
            @rect.position.should == [10, 10]
        end
        it 'assign correctly' do
            @rect.position = [5, 5]
            @rect.should == [5, 5, 20, 20]
        end
    end

end
