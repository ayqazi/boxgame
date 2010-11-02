require 'rubygems'
gem 'thoughtbot-shoulda'
gem 'mhennemeyer-matchy'
gem 'mocha'
require 'test/unit'
require 'shoulda'
require 'matchy'
require 'mocha'
require File.dirname(__FILE__) + "/../ruby/Configurator"

add_search_path(ROOTDIR + "test/unit")
add_search_path(ROOTDIR + "test/lib")
add_search_path(ROOTDIR + "spec/lib")

class Test::Unit::TestCase
    extend ShouldaMacros
end
