

class ProductsController < ApplicationController
  
  
  def index
    find_user
    @like = Like.new 

    if params[:search_txt].present?
      
      @list = Product.where(['name ILIKE ?', "%#{params[:search_txt]}%"]).order("name ASC")
    else
      @list = Product.all.order("name ASC")
    end
    @pagy, @products_list = pagy(@list,items: 8)
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
