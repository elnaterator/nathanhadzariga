class AuthController < ApplicationController

  def login
    @user = User.find_by(email: login_params['email'])
    if @user.authenticate(login_params['password'])
      # generate token
      claims = { user_id: @user.id }
      response.headers['Token'] = JWT.encode claims, 'hmacSecret', 'HS256'
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
