# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
RailsTestApp::Application.initialize!
RailsTestApp::Application.configure do
  config.action_mailer.delivery_method = :test
end
