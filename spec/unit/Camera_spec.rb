require File.dirname(__FILE__) + "/../setup.rb"

describe Camera do

    it 'centers drawable\'s view on target' do
        # screen is 100x80
        # world is 500x500
        # target is 20x30, and at (200,300) on world - center at (210, 315)
        # therefore world draw offset = (-160, -275)
        # (see doc/camera_test.odg)
        world = stub('world')
        target = stub('target') do
            stubs(:center).with().returns([210, 315])
        end

        screen = stub('screen') do
            stubs(:dimensions).with().returns([100, 80])
        end
        canvas = stub('canvas', :surface => screen)

        camera = Camera.new(:world => world, :target => target, :canvas => canvas)

        camera.world_draw_offset.should == [-160, -275]
    end

end
