class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  before_action :authenticate_user

  private

  def authenticate_user
    authenticate_with_http_token do |token,o|
      claims = AuthenticationService.decode(token)
      if claims && claims[:user_id]
        @current_token_claims = claims
        @current_user = User.find(claims[:user_id])
      end
    end
    render_unauthorized if !@current_user
  end

  def verify_admin
    render_unauthorized if !@current_user || !@current_user.admin?
  end

  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

end
