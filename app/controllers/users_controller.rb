class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  skip_before_action :authenticate_user, only: [:login]

  # GET /users
  def index
    @users = User.all.order(id: :asc)
  end

  # GET /users/1
  def show
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render :show, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render :show, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    head :no_content
  end

  # POST /users/login
  def login
    @user = User.find_by(email: login_params['email'])
    if @user.authenticate(login_params['password'])
      # generate token
      claims = { user_id: @user.id, exp: Time.now.to_i + 3600 * 24 }
      response.headers['access_token'] = AuthenticationService.tokenize claims
      render 'users/show'
    else
      render json: {}, status: 401
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def login_params
      params.require(:user).permit(:email, :password)
    end

end
