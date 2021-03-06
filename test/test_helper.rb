require 'simplecov'
require 'simplecov-lcov'

# Generate pretty report for local inspection
if ENV['LOCAL_COVERAGE']
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
end

# Generate Github Actions compatible report
if ENV['CI']
  SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
  SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter
end

SimpleCov.start 'rails'

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  setup do
    ActionMailer::Base.deliveries = []
  end

  teardown do
    Rails.cache.clear
  end
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
  include ActionView::Helpers::TextHelper
end

class ActionView::TestCase
  include Devise::Test::ControllerHelpers
end

# Construct the minimum parameters for user creation via controller action.
def build_user_params(user_obj)
  params = {
    'full_name': user_obj.full_name,
    'email': user_obj.email,
    'affiliation': user_obj.affiliation,
    'year_in_school': user_obj.year_in_school,
    'state': user_obj.state,
    'password': user_obj.password,
    'password_confirmation': user_obj.password,
  }
end

def remove_html_artifacts(email_body)
  strip_tags(email_body).gsub('=0D', '').gsub('E2=80=A6', '').gsub('=', '').gsub("\r", '').gsub("\n", '')
end
