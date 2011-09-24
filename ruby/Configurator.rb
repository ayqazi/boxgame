require 'rbconfig'

module Configurator; end # define it if it isn't already defined

if ! Configurator.const_defined?(:IS_CONFIGURED)

  # These are required before auto-loading is in place; hence we
  # have them here

  require 'logger'
  require 'pathname'
  require 'rubygems'
  require 'bundler/setup'

  # Make Configurator stuff available everywhere
  class Object
    include Configurator
  end

  # EVERYTHING GOES IN HERE to ensure 2 includes of the file don't
  # cause the stuff to be executed twice
  module Configurator

    # Setup environment
    IS_CONFIGURED = true
    # Set to directory containing ruby/config.rb
    tmprootdir =  File.dirname(__FILE__) + "/.."
    ROOTDIR = Pathname.new(tmprootdir).realpath

    DATADIR = ROOTDIR + "data"

    if ! ROOTDIR.directory?
      raise(ArgumentError,
        "Could not find Configurator::ROOTDIR #{ROOTDIR}")
    end

    # config logger
    @@logger = Logger.new(ROOTDIR + "log/debug.log")
    # @@logger = Logger.new(STDOUT)
    def logger; @@logger; end
    logger.debug("Application started, logging initialised")
    logger.debug("Configurator::ROOTDIR = #{Configurator::ROOTDIR}")

    @@search_path = [ROOTDIR + "ruby"]

    def search_path; @@search_path; end

    def add_search_path(arg)
      if ! arg.kind_of? Pathname
        raise ArgumentError, "Expected Pathname, got #{arg.class.name}"
      end
      @@search_path << arg
    end

    def require_file(arg)
      arg = Pathname.new(arg.to_str) if arg.respond_to?(:to_str)
      if arg.absolute?
        require(arg)
      else
        search_path.each { |sp|
          begin
            return require(sp + arg)
          rescue LoadError
          end
        }
        # We got here - BAD
        raise(LoadError,
          "Error loading #{arg}: load it in irb " +
                  "to see what the problem is")
      end
    end

    # We cannot do ROOTDIR.glob like below, need the files in init for this
    # to work!
    # load_on_init = ROOTDIR.glob('lib/init/**/*.rb')
    load_on_init = Pathname.glob(ROOTDIR.to_s + '/lib/init/**/*.rb')
    # Require this first, so auto-loading works for the rest of the
    # load_on_init files
    require_file load_on_init.delete(ROOTDIR + 'lib/init/Module.rb')
    load_on_init.each do |file|
      require file
    end
  end

end
