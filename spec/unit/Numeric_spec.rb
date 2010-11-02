require File.dirname(__FILE__) + "/../setup.rb"

describe Float do
    it '#close_to_zero?' do
        0.001.close_to_zero?.should == true
        0.0011.close_to_zero?.should == false
        -0.001.close_to_zero?.should == true
        -0.0011.close_to_zero?.should == false
    end
end

describe Integer do
    it '#close_to_zero?' do
        0.close_to_zero?.should == true
        1.close_to_zero?.should == false
        -1.close_to_zero?.should == false
    end
end

describe Numeric do
    it '#degrade' do
        # Degrade and round to zero
        0.1001.degrade(0.1).should == 0
        0.1001.degrade(-0.1).should == 0
        -0.1001.degrade(0.1).should == 0
        3.degrade(3).should == 0
        -3.degrade(-3).should == 0

        # Degrade but no round to zero
        0.2.degrade(0.1).should == 0.1
        -0.2.degrade(0.1).should == -0.1
        10.degrade(3).should == 7
        -10.degrade(-3).should == -7

        # Do not flip signs if value degrading by is too large
        0.1.degrade(10.1).should == 0
        -0.1.degrade(10.1).should == 0
    end

    it "#limit_distance_from_zero_to" do
        15.limit_distance_from_zero_to(12).should == 12
        3.limit_distance_from_zero_to(12).should == 3
        -15.limit_distance_from_zero_to(12).should == -12
        -3.limit_distance_from_zero_to(12).should == -3
        15.0.limit_distance_from_zero_to(12.0).should == 12.0
        3.0.limit_distance_from_zero_to(12.0).should == 3.0
        -15.0.limit_distance_from_zero_to(12.0).should == -12.0
        -3.0.limit_distance_from_zero_to(12.0).should == -3.0
    end
end
