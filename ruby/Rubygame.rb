gem 'rubygame'
require 'rubygame'

# Pull in every file from Rubygame directory
rubygame_dir = Pathname.new(__FILE__).dirname + 'Rubygame'
rubygame_dir.glob('**/*.rb').each { |file| require file }
