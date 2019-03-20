# frozen_string_literal: true

# Class OrderController
class OrdersController < ApplicationController
  before_action :check_session_kart, only: %i[index create]
  before_action :check_change_user, only: %i[index create]

  def create
    @purchase = Purchase.find(session[:kart])
    if params[:order][:quantity].to_i.positive?
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
    redirect_to(orders_path, flash: { alert: "Product Aded #{order.product.name}",
                                      alert_type: 'info' }) && return
  end

  def index
    @purchase = Purchase.find(session[:kart])
  end

  def purchase
    purchase_id = params[:purchase][:purchase_id]
    purchase_total = params[:purchase][:total]
    purchase = Purchase.find(purchase_id)
    if purchase.orders.count.positive?
      purchase.total = params[:purchase][:total].to_f
      purchase.state = 'completed'
      purchase.save
      orders = purchase.orders
      orders.each do |o|
        product = o.product
        product.stock -= o.quantity
        product.save
        send_email(product)
      end

      redirect_to(products_path, flash: { alert: "Purchase #{purchase_id} . total: #{purchase_total}", alert_type: 'warning' }) && return
    else
      redirect_to(orders_path, flash: { alert: 'No Products added to purchase', alert_type: 'danger' }) && return
    end
  end

  def purchase_log
    @purchases = Purchase.find_by_user_completed(current_user) if current_user
  end

  private

  def check_session_kart
    unless session[:kart].present?
      delete_nil_orders
      if current_user
        purchase = Purchase.find_by_user_in_progress(current_user)
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
    if session[:first_interaction] != current_user.nil?
      if current_user
        purchase = Purchase.find_by_user_in_progress(current_user)
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
    karts&.each do |k|
      k.orders.each(&:destroy)
      k.destroy
    end
  end

  def add_orders_to_purchase(purchase_send, purchase_recive)
    purchase_send.orders.each do |o|
      o.purchase = purchase_recive
      o.save
    end
    purchase_send.destroy
  end

  def send_email(product)
    if product.stock <= 3 && product.likes.size.positive?
      SendNotificationsJob.perform_later(product)
    end
  end

  def order_params
    params.require(:order).permit(:product_id, :quantity)
  end
end
