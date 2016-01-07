class AuthController < ApplicationController

  def login
    @user = User.find_by(email: login_params['email'])
    if @user.authenticate(login_params['password'])
      # generate token
      response.headers['Token'] = 'hello'
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
