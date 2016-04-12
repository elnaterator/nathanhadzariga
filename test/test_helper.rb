ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def authenticate_as user_id_or_role
    user = nil
    if user_id_or_role.is_a?(String)
      user = User.find_by(role: user_id_or_role)
    else
      user = User.find(user_id_or_role)
    end
    token = AuthenticationService.tokenize({user_id: user.id})
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(token)
    return token
  end
end
