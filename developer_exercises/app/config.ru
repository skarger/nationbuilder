$:.unshift File.dirname(__FILE__)
require "web"

use Rack::Logger
run App.freeze.app
