# config.ru

# Load the Rails application
require ::File.expand_path("../config/environment", __FILE__)

# Rack::Builder to serve your Rails application
run Rails.application
