require 'spec_setup.rb'

describe 'Additions for', Module do
    describe 'const_missing' do
        it 'raises when loading up non-existent module' do
            lambda { Nonexistent }.should raise_error(NameError)
        end

        it 'raises when loading non-existent inner module' do
            lambda { Object::Nonexistent }.should raise_error(NameError)
        end

        describe 'used from within an anonymous class' do
            before(:all) do
                @klass = Class.new do
                    def self.get_file_less_module; EmptyM; end
                    def self.get_class; EmptyM::EmptyC1; end
                    def self.get_deeply_nested_class; EmptyM::EmptyM2::EmptyC2; end
                end
            end

            it 'creates a new module when it only finds a directory by that name' do
                @klass.get_file_less_module.name.should == 'EmptyM'
                EmptyM.should be_a_kind_of(Module)
            end

            it 'loads up a class with a file' do
                @klass.get_class.name.should == "EmptyM::EmptyC1"
                EmptyM::EmptyC1.should be_a_kind_of(Class)
            end

            it 'loads up a deeply-nested class with a file' do
                @klass.get_deeply_nested_class.name.should == "EmptyM::EmptyM2::EmptyC2"
                EmptyM::EmptyM2::EmptyC2.should be_a_kind_of(Class)
            end
        end

        describe 'used from within a known, named class' do
            before(:all) do
                @klass = Object.create_temporary_class do
                    def self.get_file_less_module; EmptyM2; end
                    def self.get_class; EmptyM2::EmptyC1; end
                    def self.get_deeply_nested_class; EmptyM2::EmptyM2::EmptyC2; end
                end
            end

            it 'creates a new module when it only finds a directory by that name' do
                @klass.get_file_less_module.name.should == 'EmptyM2'
                EmptyM2.should be_a_kind_of(Module)
            end

            it 'loads up a class with a file' do
                @klass.get_class.name.should == "EmptyM2::EmptyC1"
                EmptyM2::EmptyC1.should be_a_kind_of(Class)
            end

            it 'loads up a deeply-nested class with a file' do
                @klass.get_deeply_nested_class.name.should == "EmptyM2::EmptyM2::EmptyC2"
                EmptyM2::EmptyM2::EmptyC2.should be_a_kind_of(Class)
            end
        end
    end

    describe 'find_by_name' do
        module FindByName
            module A; module B; module C; end; end; end
        end

        include FindByName

        it 'breaks' do
            lambda { Module.find_by_name("Nonexistent") }.should raise_error(NameError)
            lambda { Module.find_by_name("FindByName::Nonexistent") }.should raise_error(NameError)
            lambda { Module.find_by_name("#{self.class.name}::FindByName::Nonexistent") }.should raise_error(NameError)
        end

        describe 'works when' do
            it 'looks for a module define in Object' do
                Module.find_by_name("String").should == String
            end

            it 'looks for an deeply embedded inner object' do
            # TODO: Just saying 'A' does not work in Ruby 1.8?!?!
                Module.find_by_name("#{self.class.name}::FindByName::A::B::C").should == FindByName::A::B::C
            end
        end

        it 'works with "::M" notation' do
            # TODO: Just saying 'A' does not work in Ruby 1.8?!?!
            Module.find_by_name("::#{self.class.name}::FindByName::A").should == FindByName::A
        end
    end
end
