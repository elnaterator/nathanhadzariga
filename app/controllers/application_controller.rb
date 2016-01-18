class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  before_action :authenticate_user

  private

  def authenticate_user

    logger.info "request authentication..."

    authenticate_with_http_token do |token,o|
      claims = AuthenticationService.decode(token)
      if claims && claims[:user_id]
        @current_token_claims = claims
        @current_user = User.find(claims[:user_id])
      end
    end

    if !@current_user
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end

  end
end
