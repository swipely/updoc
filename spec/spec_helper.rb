$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'updoc'

# Load rspec support files
Dir['./spec/support/**/*.rb'].sort.each { |f| require f }
