# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
RailsTestApp::Application.initialize!
RailsTestApp::Application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_options = {from: 'info@pcin.cz'}
  config.action_mailer.smtp_settings = {
      address: 'localhost',
      port: 25,
      enable_starttls_auto: false
  }
end
