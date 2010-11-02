require File.dirname(__FILE__) + "/../setup.rb"

require 'rbconfig'

describe Configurator do
    it 'is configured' do
        # If we get this far, it all loads up and works - there should be no
        # warnings

        # Test that loading config multiple times won't cause it to be
        # evaluated multiple times
        require File.dirname(__FILE__) + "/../../ruby/../ruby/Configurator"
    end

    it 'finds constants that were included in Object' do
        Configurator::ROOTDIR.object_id.should == Object::ROOTDIR.object_id
        Configurator::DATADIR.object_id.should == Object::DATADIR.object_id
        ConfiguratorTestStuffInObject.what_is_this?.should == true
    end

    it 'uses correct Ruby version' do
        RbConfig::CONFIG.values_at('MAJOR', 'MINOR').should == ['1', '9']
    end
end
