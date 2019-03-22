# frozen_string_literal: true

# Class OrderController
class OrdersController < ApplicationController
  
  include CartInitAndCheck
  before_action :check_session_kart, only: %i[create]
  before_action :check_change_user, only: %i[create]

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
    redirect_to(purchases_path, flash: { alert: "Product Aded #{order.product.name}",
                                      alert_type: 'info' }) && return
  end

private

def order_params
    params.require(:order).permit(:product_id, :quantity)
  end
end
