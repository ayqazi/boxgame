require File.dirname(__FILE__) + '/../ruby/Configurator.rb'
add_search_path(ROOTDIR + "spec/lib")

gem 'mocha'
gem 'rspec'

Spec::Runner.configure do |config|
    config.mock_with :mocha
    # For more information take a look at Spec::Runner::Configuration and Spec::Runner

    Dir.glob(File.dirname(__FILE__) + '/matchers/**/*.rb') do |filename|
        filename = Pathname.new(filename)
        module_name = filename.basename.to_s.gsub(/\.rb$/, '')
        require filename
        config.include(Module.find_by_name(module_name))
    end
end

class Object
    def self.create_temporary_class(&block)
        class_name = "TemporaryClass#{rand(9999999)}"
        Object.const_set(class_name, Class.new(&block))
        return const_get(class_name)
    end
end
