class LikesController < ApplicationController
    
    def create
        puts "----------------------------"
        like = Like.where(["user_id = ? and product_id = ?", params[:like][:user], params[:like][:product]]).first
        puts "Like: ---->#{like}"
        if like.nil? 
            like = Like.new
            like.product = Product.find(params[:like][:product])
            like.user = User.find(params[:like][:user])
            like.save
        else
            like.delete
            Product.reset_counters(params[:like][:product], :likes)
        end 
        
        redirect_to products_path and return
                        
    end

    def like_params
        params.require(:like).permit(:user, :product) rescue {}
    end
    
end
