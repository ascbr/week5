

class ProductsController < ApplicationController
  
  
  def index
    find_user
    @pagy, @products_list = pagy(Product.all.order("name ASC"))
    
  end

  def show 
    find_user
    @id = params[:id_product]
    @product = Product.find(@id)
    
    if params[:buyed]
      @purchase = Purchase.where(["user = ? and state = ?", @user, "in progress"])
      if(@purchase == nil)
        #@purchase = Purchase.new
        #@purchase.user = @user
        #@purchase.state = 'in progress'
        #@purchase.total = 0.0
        #Purchase.save(@purchase)

      end
      
      product_to_buy = Product.find(params[:id_product])
      if params[:quantity].to_i > product_to_buy.stock

      else
        redirect_to products_path, flash: { alert: "Added to car.", alert_type: 'success' }
      end  

    end

    def find_user
      if current_user
        @user = User.find(current_user.id)
      else
        @user = User.new
        @user.name = 'Anonymous'
      end
      @user
    end
 
  end
end
