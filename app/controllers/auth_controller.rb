class AuthController < ApplicationController

  def login
    @user = User.find_by(email: login_params['email'])
    if @user.authenticate(login_params['password'])
      # generate token
      claims = { user_id: @user.id, exp: Time.now.to_i + 3600 * 24 }
      response.headers['Token'] = AuthenticationService.tokenize claims
      render 'users/show'
    else
      render json: {}, status: 401
    end
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end

end
