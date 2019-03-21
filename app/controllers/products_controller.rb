require 'securerandom'

# frozen_string_literal: true
class ProductsController < ApplicationController

  before_action :all_categories, only: %i[index new edit]
  before_action :check_admin, except: %i[index show]


  def index
    @search = OpenStruct.new(
      params.fetch(:search, {})
    )

    @user = current_user
    @like = Like.new
    
    if params[:search].present?
      @list = Product.with_attached_image.find_by_status1.order_by(params[:search][:order_by])
    else
      @list = Product.with_attached_image.find_by_status1.order_by_name
    end
    @list = @list.find_by_name("%#{params[:search][:search_txt]}%") if params[:search].present?
    @list = @list.find_by_category_id(params[:search][:category_id]) if params[:search].present? and params[:search][:category_id] != '0'
    @pagy, @products_list = pagy(@list, items: 8)
  end

  def show
    if params[:id].present?
      @product = Product.find_by(id: params[:id])

      if @product.nil?
        redirect_to products_path, flash: { alert: "Product not found", 
                                            alert_type: 'info' } and return
      end
      
      @commentable = @product
      @comments = @commentable.comments
      @comment = Comment.new
    end
  end

  def new
    @product = Product.new
  end

  def create
    if params[:product][:stock].to_i.positive && params[:product][:price].to_i.positive
      
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
      @product = Product.find(params[:id])
  
  end

  def update
    product = Product.find(params[:id])
    product.update!(product_params)
    redirect_to product_path(params[:id])
  end

  def destroy
    product = Product.find(params[:id])
    product.status = 0
    product.save

    redirect_to products_path, flash: { alert: "Product out of list", 
      alert_type: 'info' } and return

  end

  private

  def check_admin
    unless current_user && current_user.has_role?(:admin)
      redirect_to products_path, flash: { alert: "Access denied", 
        alert_type: 'info' } and return
      end
    end

  def all_categories
    @categories = Category.all.order_by_name
  end

  def product_params
    params.require(:product).permit(:name, :stock, :price, :category_id, :image)
  end
end
