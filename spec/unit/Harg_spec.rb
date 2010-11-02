require File.dirname(__FILE__) + '/../setup.rb'

describe Harg do

    describe 'harg!' do

        it 'expect hash parameter to be supplied' do
            a_class = Class.new do
                hargdef :initialize do
                    harg! :i
                end
            end

            lambda { a_class.new }.should raise_error(Harg::Error)
        end

        it 'return expected hash parameter' do
            a_class = Class.new do
                attr :i
                hargdef :initialize do
                    @i = harg! :i
                end
            end

            o = a_class.new(:i => 4)
            o.i.should == 4
        end

    end

    describe 'harg' do

        before do
            @a_class = Class.new do
                attr :i
                hargdef :initialize do
                    @i = harg :i
                end
            end
        end

        it 'not expect hash parameter if not set' do
            o = @a_class.new
            o.i.should == nil
        end

        it 'return expected hash parameter' do
            o = @a_class.new(:i => 4)
            o.i.should == 4
        end

    end

    describe 'hargs!' do

        before do
            @a_class = Class.new do
                attr :i
                attr :j

                hargdef :initialize do
                    @i, @j = hargs!(:i, :j)
                end
            end
        end

        it 'fail if not all arguments were supplied' do
            lambda { @a_class.new(:i => 4) }.should raise_error(Harg::Error)
        end

        it 'give back all its arguments' do
            o = @a_class.new(:i => 3, :j => 4)
            [o.i, o.j].should == [3, 4]
        end

    end

    describe 'harg-using method called from within another harg-using method' do

        it 'get harg from correct methods parameters' do

            a_class = Class.new do
                attr_accessor :a_from_initialize, :b_from_initialize, :a_from_init2, :b_from_init2, :a_from_init3, :b_from_init3

                hargdef :initialize do
                    self.a_from_initialize = harg :a
                    init2(:a => 'a_from_init2', :b => 'b_from_init2')
                    self.b_from_initialize = harg! :b
                end

                hargdef :init2 do
                    self.a_from_init2 = harg :a
                    init3(:a => 'a_from_init3', :b => 'b_from_init3')
                    self.b_from_init2 = harg! :b
                end

                hargdef :init3 do
                    self.a_from_init3 = harg :a
                    self.b_from_init3 = harg! :b
                end

            end

            a = a_class.new :a => 'a_from_initialize', :b => 'b_from_initialize'

            a.a_from_init3.should == 'a_from_init3'
            a.b_from_init3.should == 'b_from_init3'
            a.a_from_init2.should == 'a_from_init2'
            a.b_from_init2.should == 'b_from_init2'
            a.a_from_initialize.should == 'a_from_initialize'
            a.b_from_initialize.should == 'b_from_initialize'
        end

        it 'allow use of #using_hargs inside non-hargdef methods' do
            a_class = Class.new do
                attr_accessor :a_from_initialize, :b_from_initialize, :a_from_init2, :b_from_init2, :a_from_init3, :b_from_init3

                def initialize(args)
                    using_hargs(args) do
                        self.a_from_initialize = harg :a
                        init2(:a => 'a_from_init2', :b => 'b_from_init2')
                        self.b_from_initialize = harg! :b
                    end
                end

                def init2(args)
                    using_hargs(args) do
                        self.a_from_init2 = harg :a
                        init3(:a => 'a_from_init3', :b => 'b_from_init3')
                        self.b_from_init2 = harg! :b
                    end
                end

                def init3(args)
                    using_hargs(args) do
                        self.a_from_init3 = harg :a
                        self.b_from_init3 = harg! :b
                    end
                end

            end

            a = a_class.new :a => 'a_from_initialize', :b => 'b_from_initialize'

            a.a_from_init3.should == 'a_from_init3'
            a.b_from_init3.should == 'b_from_init3'
            a.a_from_init2.should == 'a_from_init2'
            a.b_from_init2.should == 'b_from_init2'
            a.a_from_initialize.should == 'a_from_initialize'
            a.b_from_initialize.should == 'b_from_initialize'
        end

    end

    describe "doing next in a hargdef block" do

        before do
            @a_class = Class.new do
                hargdef :square_a do
                    a = harg! :a
                    next a**2
                end

                hargdef :add_a_to_its_square do
                    a = harg! :a
                    next a + square_a(:a => a)
                end
            end
        end

        it 'work for single-level methods' do
            obj = @a_class.new
            obj.square_a(:a => 3).should == 9
            obj.square_a(:a => 4).should == 16
        end

        it 'work for nested methods' do
            obj = @a_class.new
            obj.add_a_to_its_square(:a => 3).should == 12
        end
    end

end
