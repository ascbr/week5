

class ProductsController < ApplicationController
  
  
  def index
    find_user
    @pagy, @products_list = pagy(Product.all.order("name ASC"))
    
  end

  def show 
    find_user
    @id = params[:id_product]
    @product = Product.find(@id)
    
    @purchase = Purchase.where(["user_id = ? and state = ?", @user.id, "in progress"]).first
    
    if(!@purchase)
        @purchase = Purchase.new
        @purchase.user = @user
        @purchase.state = 'in progress'
        @purchase.total = 0.0
        @purchase.purchase_date = Time.now
        @purchase.save
      
    end

  end

  def find_user
    if current_user
      @user = User.find(current_user.id)
    else
      @user = User.new
      @user.username = 'Anonymous'
    end
      @user
  end
 
end
