class CommentsController < ApplicationController

  skip_before_action :authenticate_user, only: [:index, :show]
  before_action :set_comment, only: [:show, :update, :destroy]

  def index
    @comments = Post.find(comment_params[:post_id]).comments
  end

  def show
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      render :show, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    render_unauthorized && return if (@comment.author_id != @current_user.id) && !@current_user.admin?
    if @comment.update(comment_params)
      render :show, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render_unauthorized && return if (@comment.author_id != @current_user.id) && !@current_user.admin?
    @comment.destroy
    head :no_content
  end

  private

  def set_comment
    begin
      @comment = Post.find(comment_params[:post_id]).comments.find(comment_params[:id])
    rescue
      head 404
    end
  end

  def comment_params
    params.permit(:post_id, :id, :body, :author_id)
  end

end
