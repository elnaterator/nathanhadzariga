class PostsController < ApplicationController

  skip_before_action :authenticate_user, only: [:index, :show]

  before_action :verify_admin, only: [:create, :update, :destroy]
  before_action :set_post, only: [:show, :update, :destroy]

  def index
    @posts = Post.order(created_at: :desc)
  end

  def show
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      render :show, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render :show, status: :ok, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    head :no_content
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.permit(:title, :body, :author_id)
  end

end
