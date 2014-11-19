# Load the Rails application.
require File.expand_path('../application', __FILE__)

require 'rack/fiber_pool'
Rails::Initializer.run do |config|
  config.middleware.use Rack::FiberPool
  config.threadsafe!
end

# Initialize the Rails application.
Rails.application.initialize!
