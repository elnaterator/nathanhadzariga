class UsersController < ApplicationController

  skip_before_action :authenticate_user, only: [:login, :signup]

  before_action :verify_admin, only: [:index, :create]

  before_action :set_user, only: [:show, :update, :destroy]
  before_action :verify_self_or_admin, only: [:show, :update, :destroy]


  # POST /users/login
  def login
    @user = User.find_by(:email => user_params['email'])
    if @user.authenticate(user_params['password'])
      set_access_token @user
      render 'users/show'
    else
      render_unauthorized
    end
  end

  # POST /users/signup
  def signup
    @user = User.new(user_params)
    if @user.save
      set_access_token @user
      render :show, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

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

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.permit(:name, :email, :password, :password_confirmation)
    end

    def verify_self_or_admin
      return if @user && @user.id == @current_user.id
      verify_admin
    end

    def set_access_token user
      claims = { user_id: user.id, exp: Time.now.to_i + 3600 * 24, role: user.role }
      response.headers['access_token'] = AuthenticationService.tokenize claims
    end

end
