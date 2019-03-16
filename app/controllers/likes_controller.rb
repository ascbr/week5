# frozen_string_literal: true
class LikesController < ApplicationController
  def create
    like = Like.where(['user_id = ? and product_id = ?', current_user.id, 
        params[:like][:product]]).first

    if like.nil?
      like = Like.new
      like.product = Product.find(params[:like][:product])
      like.user = User.find(current_user.id)
      like.save
    else
      like.destroy

    end

    redirect_to(products_path) && return
  end

  def like_params
    params.require(:like).permit(:user, :product)
  rescue StandardError
    {}
  end
end
