# Class OrderController
class OrdersController < ApplicationController
  before_action :check_session_kart, only: [:index, :create]
  before_action :check_change_user, only: [:index, :create]

  def create
    @purchase = Purchase.find(session[:kart])
    puts "---------------->"+@purcahse.inspect
    puts "---------------->"+session[:kart].inspect
    if params[:order][:quantity].to_i > 0
      if @purchase
        order = Order.find_by(purchase_id: @purchase.id,
                                         product_id: params[:order][:product_id])
        if order
          order.quantity += params[:order][:quantity].to_i
        else
          order = Order.new(order_params)
          order.purchase_id = @purchase.id
        end
        order.save
      end
    end

    redirect_to orders_path, flash: { alert: "Product Aded #{order.product.name}",
      alert_type: 'info' } and return
  end
  
  def index
    @purchase = Purchase.find(session[:kart])
  
  end


  def purchase
    
  end

  def purchase_log
    if current_user
      @purchases = Purchase.where(['user_id = ? and state = ?', 
        current_user.id, 'completed'])
    end
  end

  private

  def check_session_kart
    if !session[:kart].present?
      delete_nil_orders
      if current_user
        purchase = Purchase.find(user_id: current_user, state: 'in_progress')
        if purchase
          session[:kart] = purchase_id
        else
          purchase = Purchase.new
          purchase.state = 'in_progress'
          purchase.user = current_user
          purchase.save
          session[:kart] = Purchase.last.id
        end
      else
        
        purchase = Purchase.new
        purchase.state = 'in_progress'
        purchase.save
        session[:kart] = Purchase.last.id
      end
      session[:first_interaction] = current_user.nil?
    end
  end

  def check_change_user
    if  session[:first_interaction] != current_user.nil?
      if current_user
        purchase = Purchase.find_by(user_id: current_user.id, state: 'in_progress')
        if purchase
          purchase_send = Purchase.find(session[:kart])
          add_orders_to_purchase(purchase_send, purchase)
          session[:kart] = purchase.id
        else
          purchase = Purchase.find(session[:kart])
          purchase.user = current_user
          purchase.save
        end
      else
        session[:kart] = nil
        delete_nil_orders
      end
      session[:first_interaction] = current_user.nil?
    end
  end

  def delete_nil_orders
    karts = Purchase.where(user_id: nil)
    if !karts.nil?
      karts.each do |k|
        k.orders.each do |o|
          o.destroy
        end
        k.destroy
      end
    end
  end

  def add_orders_to_purchase(purchase_send, purchase_recive)
    purchase_send.orders.each do |o|
      o.purchase = purchase_recive
      o.save
    end
    purchase_send.destroy
  end

  def order_params
    params.require(:order).permit(:product_id, :quantity)
  end

end
