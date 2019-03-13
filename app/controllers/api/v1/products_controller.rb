module API
  module V1
    class ProductsController < ApplicationController
      respond_to :json
      def index
        if params[:order_by].present? && params[:order_by] == "likes"
          @list = Product.all.order(likes_count: :ASC)
        else
          @list = Product.all.order(name: :ASC)
        end

        @list = @list.where('name ILIKE ?', "%#{params[:name]}%") if [:name].present?
        @list = @list.where('category_id = ?', params[:category_id]) if params[:category_id].present? and params[:category_id] != '0'
        @pagy, @products_list = pagy(@list, items: 8)
        respond_with @products_list
      end
    end
  end
end
