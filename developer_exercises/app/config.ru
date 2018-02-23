$:.unshift File.dirname(__FILE__)
require "web"

run App.freeze.app
