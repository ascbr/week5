require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'index response' do
    get products_url
    assert_response :success
  end

  test 'new product not admin' do
    get '/products/new'
    assert_response :redirect
  end

  test 'show product response' do
    rand_number = Random.new(12)
    id = rand_number.rand(1..9)
    get "/products/#{id}"
    assert_response :redirect
  end

end
