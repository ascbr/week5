class UsersController < ApplicationController

  before_action :check_valid_user, only: [:show]
  before_action :check_admin_user, only: [:pending_comments]
  def index
    @users = User.all
  end

  def show
    
    @commentable = @user
    @comments = @commentable.comments.where(state: 1)
    @comment = Comment.new
  end

  def pending_comments
    @comments_pending = Comment.where(commentable_type: 'User', state: 0).all
  end

  def comment_aproved
    comment = Comment.where(id: params[:comment_id]).first
    if comment
      comment.state = 1
      comment.save
      redirect_back(fallback_location: pending_comments_users_path)
    else
      redirect_to users_path and return
    end

  end

  private

  def check_valid_user
    unless @user = User.where(id: params[:id]).first
      redirect_to users_path and return
    end
  end

  def check_admin_user
    if current_user.nil? || !current_user.has_role?(:admin)
      redirect_to users_path and return
    end
  end



end