require File.dirname(__FILE__) + "/../setup.rb"

describe World do

    before(:each) do
        World.any_instance.stubs(:create_walls)
    end

    def stub_out_irrelevant_ops(world)
        stub_bg = stub("stub_bg", :blit => nil)
        world.instance_eval { @bg = stub_bg }
    end

    describe World do

        describe 'adding an entity' do
            it 'set the entities #world attribute to me' do
                world = World.new
                stub_entity = stub('stub_entity') do
                    expects(:container=).with(world)
                end
                world.add_entity(stub_entity)
            end
        end

        describe "#draw" do
            before(:each) do
                @stub_canvas = stub("stub_canvas", :surface => stub)
                @offset = [1, 2]

                @world = World.new
                stub_out_irrelevant_ops(@world)
            end

            it "pass offset supplied to sub_entities" do
                stub_entity = stub("stub_entity", :container= => nil)
                stub_entity.expects(:draw).with(@stub_canvas, @offset)
                @world.add_entity(stub_entity)
                @world.draw(@stub_canvas, @offset)
            end

            it "not let offset change if sub_entities decide to change it" do
                test_entity_class = Class.new(FakeEntity) do
                    def draw(canvas, offset)
                        offset[0] = 1000000000
                    end

                    def container=(w); end
                end

                offset_clone = @offset.clone
                entity = test_entity_class.new
                @world.add_entity(entity)
                @world.draw(@stub_canvas, @offset)
                @offset.should == offset_clone
            end
        end

        describe '#update' do
            it 'update all entities' do
                world = World.new
                entity1 = FakeEntity.new(:container => world)
                entity2 = FakeEntity.new(:container => world)

                entity1.expects(:update)
                entity2.expects(:update)

                world.update
            end
        end
    end
end
