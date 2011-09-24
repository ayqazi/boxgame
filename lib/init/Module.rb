class Module
  alias_method :original_const_missing, :const_missing

  # Take "A::B::C", etc, return A::B::C.  Only absolute names work

  def self.find_by_name(name)
    components = name.split("::")

    # Deal with '::Module' notation
    if components[0] == ""
      components.shift
    end

    curmod = Object

    components.each { |i|
      if curmod.name == name
        return curmod
      else
        curmod = curmod.const_get(i)
      end
    }

    return curmod
  end

  def const_missing_helper(sym)
    if self.name.nil?
      # Re-start from Object
      logger.debug("Anonymous class detected: calling Object.const_missing_helper(#{sym.inspect})")
      return Object.const_missing_helper(sym)
    end

    container_loc = if self == Object
      ""
    else
      self.name.split("::").join("/")
    end

    # First look for the file in each search path
    search_path.each { |sp|
      dsoext = Config::CONFIG["DLEXT"]

      rbfpath = sp + container_loc + "#{sym.to_s}.rb"
      dsofpath = sp + container_loc + "#{sym.to_s}.#{dsoext}"

      if(rbfpath.exist?)
        logger.debug("Trying to require #{rbfpath}")
        require rbfpath
        return self.const_get(sym)
      elsif(dsofpath.exist?)
        logger.debug("Trying to require #{dsofpath}")
        require dsofpath
        return self.const_get(sym)
      end
    }

    # Else look for a directory of the name, and create a module
    # for it
    search_path.each { |sp|
      # puts(sp + rel_outer_dir + sym.to_s)
      if((sp + container_loc + sym.to_s).directory?)
        logger.debug "Evaluating the following in #{name} scope:"
        logger.debug "const_set('#{sym}', Module.new)"
        self.const_set(sym.to_s, Module.new)
        return self.const_get(sym)
      end
    }

    # Now chop off the end of the container, and carry on looking
    # below; unless we're out of containers, in which case return
    # nil
    if self == Object
      return nil
    else
      next_container_name = self.name.split("::")[0..-2].join("::")
      next_container = if next_container_name.empty?
        Object
      else
        Module.find_by_name(next_container_name)
      end

      logger.debug("#{self.name}#const_missing_helper is going " +
                "to the next outer containing class " +
                "'#{next_container.name}' " +
                "to look for '#{sym}'")
      return next_container.const_missing_helper(sym)
    end
  end

  def const_missing(sym)
    logger.debug("#{self.name}#const_missing() called " +
              "with arg (#{sym.inspect})")

    # const_missing will not be called for something already
    # defined normally, i.e. when doing A::B, but if
    # const_missing is called manually, it will be used
    if(self.constants.collect {|i| i.to_s}.include?(sym.to_s))
      logger.debug("#{self.name}#const_missing() - " +
                "Already have #{sym}")
      return self.const_get(sym)
    end

    # First try to load class/module from the application's
    # Configurator.search_path

    retval = self.const_missing_helper(sym)
    return retval if retval

    # Now try to load it from default Ruby path

    # Convert class name to a path, and downcase it ala silly
    # Ruby standards

    # Got here, so bomb out
    original_const_missing(sym)

  end # def const_missing

end # class Module
