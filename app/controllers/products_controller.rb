require 'securerandom'

# frozen_string_literal: true
class ProductsController < ApplicationController
  def index
    @search = OpenStruct.new(
      params.fetch(:search, {})
    )

    @user = current_user
    @like = Like.new
    @categories = Category.all.order(name: :ASC)
    if params[:search].present?
      @list = Product.where(status: 1).order(params[:search][:order_by])
    else
      @list = Product.where(status: 1).order(name: :ASC)
    end
    @list = @list.where('name ILIKE ?', "%#{params[:search][:search_txt]}%") if params[:search].present?
    @list = @list.where('category_id = ?', params[:search][:category_id]) if params[:search].present? and params[:search][:category_id] != '0'
    @pagy, @products_list = pagy(@list, items: 8)
  end

  def show
    if params[:id].present?
      @product = Product.where(id: params[:id]).first
      
      if @product.nil?
        redirect_to products_path, flash: { alert: "Product not found", 
          alert_type: 'info' } and return
      end
    end
  end

  def new
    if current_user && current_user.has_role?(:admin)
      @product = Product.new
      @categories = Category.all.order(:name)
    else 
      redirect_to products_path, flash: { alert: "Access denied", 
                                        alert_type: 'info' } and return
    end
  end

  def create
    if params[:product][:stock].to_i > 0 && params[:product][:price].to_i > 0 
      product = Product.new(product_params)
      product.sku = SecureRandom.uuid
      product.status = 1
      product.save
      redirect_to product_path(Product.last), flash: { alert: "New product created: #{product.name}", 
                                          alert_type: 'success' } and return
    else
      redirect_to new_product, flash: { alert: "Invalid parameters", 
                                        alert_type: 'danger' } and return
    end
  end

  def edit
    if current_user && current_user.has_role?(:admin)
      @product = Product.find(params[:id])
      @categories = Category.all.order(:name)
    else 
      redirect_to products_path, flash: { alert: "Access denied", 
                                        alert_type: 'info' } and return
    end
  end

  def update
    product = Product.find(params[:id])
    product.update!(product_params)
    redirect_to product_path(params[:id])
  end

  def destroy
    if current_user && current_user.has_role?(:admin)
      product = Product.find(params[:id])
      product.status = 0
      product.save
      
      redirect_to products_path
    else
      redirect_to products_path, flash: { alert: "Access denied", 
                                        alert_type: 'info' } and return
    end

  end

  private
  def product_params
    params.require(:product).permit(:name, :stock, :price, :category_id, :image)
  end
end
