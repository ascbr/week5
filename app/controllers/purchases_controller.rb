# frozen_string_literal: true
class PurchasesController < ApplicationController
  include CartInitAndCheck
  before_action :check_session_kart, only: %i[index create]
  before_action :check_change_user, only: %i[index create]


  def index
    @purchase = Purchase.find(session[:kart])
  end
    
  def update
    purchase_id = session[:kart]
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
      session[:kart]=nil
      redirect_to(products_path, flash: { alert: "Purchase #{purchase_id} . total: #{purchase_total}", alert_type: 'warning' }) && return
    else
      redirect_to(orders_path, flash: { alert: 'No Products added to purchase', alert_type: 'danger' }) && return
    end
  end

  def purchase_log
    @purchases = Purchase.find_by_user_completed(current_user) if current_user
    
  end
    
  private
    
  def send_email(product)
    if product.stock <= 3 && product.likes.size.positive?
      SendNotificationsJob.perform_later(product)
    end
  end

end