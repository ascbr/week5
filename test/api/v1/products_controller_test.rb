module API
  module V1
    class ProductsControllerTest < ActionDispatch::IntegrationTest
      
      test 'producst api index' do
        get  api_v1_products_url
        assert_response :success
      end

      test 'producst api search' do
        product = products(:one)
        get  api_v1_products_url
        assert_response :success, params: {search:{name: product.name}}
      end

      test 'producst api search render' do
        product = products(:one)
        get  api_v1_products_url, params: {name: product.name}
        response_id = JSON.parse(response.body)[0]['id']
        assert_equal product.id, response_id 
      end

      

    end
  end 
end
