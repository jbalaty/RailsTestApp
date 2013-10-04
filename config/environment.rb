# Load the Rails application.
require File.expand_path('../application', __FILE__)

puts 'Processing config file'

# Initialize the Rails application.
RailsTestApp::Application.initialize!
RailsTestApp::Application.configure do
  config.action_mailer.delivery_method = :test
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_options = {from: 'info@pcin.cz'}
end
