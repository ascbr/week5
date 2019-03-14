# frozen_string_literal: true
class ProductsController < ApplicationController
  def index
    @search = OpenStruct.new(
      params.fetch(:search, {})
    )

    @like = Like.new
    @categories = Category.all.order(name: :ASC)
    if params[:search].present?
      @list = Product.all.order(params[:search][:order_by])
    else
      @list = Product.all.order(name: :ASC)
    end
    @list = @list.where('name ILIKE ?', "%#{params[:search][:search_txt]}%") if params[:search].present?
    @list = @list.where('category_id = ?', params[:search][:category_id]) if params[:search].present? and params[:search][:category_id] != '0'
    @pagy, @products_list = pagy(@list, items: 8)
  end

  def show
    @id = params[:id]
    @product = Product.find(@id)

    @purchase = Purchase.where(['user_id = ? and state = ?', current_user.id, 'in progress']).first

    unless @purchase
      @purchase = Purchase.new
      @purchase.user = current_user
      @purchase.state = 'in progress'
      @purchase.total = 0.0
      @purchase.purchase_date = Time.now
      @purchase.save

    end
  end

  def new
    @product = Product.new
    @categories = Category.all.order(:name)
  end
  
  private
  
  def product_params

  end 

end
