

class ProductsController < ApplicationController
  
  
  def index
    
    @search = OpenStruct.new(
      params.fetch(:search, {})
    )

    @like = Like.new
    @categories = Category.all.order(name: :ASC)
    @list = 
    if params[:search].present? && params[:search][:search_txt]
      Product.where(['name ILIKE ?', "%#{params[:search][:search_txt]}%"])
    elsif params[:search].present? && params[:search][:category]
      Product.where(['category_id = ?', "#{params[:search][:category]}"])
    else
      Product.all.order(name: :ASC)
    end
    @pagy, @products_list = pagy(@list, items: 8)
  end

  def show 
    
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
  
 
end
