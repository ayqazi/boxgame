require File.dirname(__FILE__) + '/../setup.rb'

describe Vector do

    it '#degrade s' do
        Vector[1.0, 0.1009].degrade(0.1).should == Vector[0.9, 0.0]
    end

    it '#limit_distance_from_zero_to(4)' do
        Vector[5.1, 3.0].limit_distance_from_zero_to(4).should == Vector[4, 3.0]
    end

    it 'allows updates' do
        v = Vector[0, 1]
        v[0] = 2
        v.should == Vector[2, 1]
    end

    it 'does not allow assignment outside range' do
        v = Vector[0, 1]
        lambda { v[2] = 3 }.should raise_error(RangeError)
    end

    it '#collect!' do
        v = Vector[1,2,3]
        v.collect! { |i| i*2}.should == v
        v.should == Vector[2, 4, 6]
    end

    it 'negates its values with -@' do
        v = Vector[1.2, -3]
        (-v).should == Vector[-1.2, 3]
    end

    it 'divides all elements by given scalar' do
        v = Vector[12, -7.5]
        (v/3).should == Vector[4, -2.5]
        (v/4).should == Vector[3, -1.875]
    end
end
