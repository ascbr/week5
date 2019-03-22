class CommentsController < ApplicationController
  before_action :load_commentable

  def index
    @comments = @commentable.comments
  end

  def new
    @comment = @commentable.comments.new
  end

  def create
    if(@commentable.class == Product)
      @comment = @commentable.comments.new(allowed_params_product)
      if @comment.save
        redirect_to product_path(@commentable.id)
      else
        redirect_to products_path
      end
    else
      @comment = @commentable.comments.new(allowed_params_user)
      if @comment.save
        redirect_to user_path(@commentable.id)
      else
        redirect_to users_path
      end
    end
  end

  private

  def load_commentable
    resource, id = request.path.split('/')[1,2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def allowed_params_product
    params.require(:comment).permit(:content).merge(
      user_id: current_user.id, state: 0
    )
  end

  def allowed_params_user
    params.require(:comment).permit(:content).merge(
      user_id: current_user.id, state: 0
    )
  end
end
