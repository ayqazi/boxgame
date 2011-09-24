require 'spec_setup.rb'

describe EventsPerPeriodTracker do

  def events_got=(value); value.should be_kind_of(EventsPerPeriodTracker); @events_got = value.to_f; end

  before do
    @fps = EventsPerPeriodTracker.new(:period_length => 2.0, &self.method(:events_got=))
  end

  describe 'outputting the fps info' do

    before do
      @fps.stubs(:elapsed_since_start).with().returns(0.0)
    end

    it "returns frames per second as string in response to to_s" do
      @fps.to_s.should == "0.0"
    end

    it "returns frames per second as floating point in response to to_f" do
      @fps.to_f.should == 0.0
    end

    it 'returns frames per second as nice short string rounded to nearest 0.1 when to_f returns a long float' do
      @fps.stubs(:to_f).with().returns(12.34325444445)
      @fps.to_s.should == '12.3'
      @fps.stubs(:to_f).with().returns(24.9732)
      @fps.to_s.should == '25.0'
    end

  end

  it 'still works if no block specified' do
    fps = EventsPerPeriodTracker.new(:period_length => 1.0)
    fps.stubs(:elapsed_since_start).with().returns(1.0)
    4.times { fps.event! }
    fps.update
    fps.to_f.should == 4.0
  end

  describe '#event!' do
    it 'returns EventsPerPeriodTracker so we can do more stuff on it' do
      @fps.event!.update
    end
  end

  it '#elapsed_since_start returns time since FPS object was created' do
    sleep 0.5
    (@fps.elapsed_since_start - 0.5).should < 0.05
  end

  it "returns the correct value for to_f and call the callback at the right time" do

    @fps.stubs(:elapsed_since_start).with().returns(0.0)
    @fps.to_f.should == 0.0

    4.times { @fps.event! }
    @fps.stubs(:elapsed_since_start).with().returns(1.999)
    @fps.update
    @fps.to_f.should == 0.0

    @fps.stubs(:elapsed_since_start).with().returns(2.0)
    @fps.update
    @events_got.should == 2 # (4 / 2.0)
    @fps.to_f.should == @events_got

    5.times { @fps.event! }
    @fps.stubs(:elapsed_since_start).with().returns(4.200)
    @fps.update
    @events_got.should == (5.0 / (4.2-2.0))
    @fps.to_f.should == @events_got
    # i.e. between second 2 and 4, 5 frames were processed

    6.times { @fps.event! }
    @fps.stubs(:elapsed_since_start).with().returns(7.400)
    @fps.update
    @fps.to_f.should == (6.0 / (7.4 - 4.2))
    @fps.to_f.should == @events_got
    # i.e. between second 4 and 7, 5 frames were processed - so that's 6/3 = 2
  end
end
