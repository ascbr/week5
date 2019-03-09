class OrdersController < ApplicationController

  def create
    order = Order.new
    order.purchase = Purchase.find(params[:order][:purchase_id])
    order.product = Product.find(params[:order][:product_id])
    order.quantity = params[:order][:quantity]
    order.save
    #order.create(params[:order])
    redirect_to products_path, flash: { alert: "Added to car.", alert_type: 'success' }
  end

  def index
    @user = current_user
    if @user
      @purchase = Purchase.where(["user_id = ? and state = ?", @user.id, "in progress"]).first
      if(!@purchase)
        @alert = "Purchase with no orders"
      else
        @orders = @purchase.orders
      end
    else
      @alert = "Please log in to add products to the cart"  
    end 
    
  end


  def purchase
    
      @purchase_id = params[:purchase][:purchase_id]
      @purchase_total = params[:purchase][:total]
      purchase = Purchase.find(@purchase_id)
      if purchase.orders.count >0
      purchase.total = params[:purchase][:total].to_f
      purchase.state = 'completed'
      purchase.save
      orders = purchase.orders
      
      orders.each do |o|
        product = o.product
        product.stock -= o.quantity
        product.save
      end
      redirect_to products_path, flash: { alert: "Purchase #{@purchase_id} . total: #{@purchase_total}", alert_type: 'warning' } and return
    else 
      redirect_to orders_path,  flash: { alert: "No Products added to purchase", alert_type: 'danger' } and return
    end
    
    
  end
  
  def purchase_log

    if current_user
      @purchases = Purchase.where(["user_id = ? and state = ?", current_user.id, "completed"])
    else 

    end
  end 

  private

  def order_params
    params.require(:order).permit(:purchase_id, :product_id, :quantity)
  end

end
