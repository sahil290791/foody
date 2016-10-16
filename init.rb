APP_ROOT = File.dirname(__FILE__)

# requiring guide.rb
# require File.join(APP_ROOT,"lib","guide")
$:.unshift(File.join(APP_ROOT,"lib"))
require "guide"

guide  = Guide.new('restaurant.txt')
guide.launch!
