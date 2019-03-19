require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'index response' do
    get products_url
    assert_response :success
  end

  test 'new product client' do
    get '/products/new'
    assert_response :redirect
  end

  test 'show product response' do
    product = products(:one)
    get "/products/#{product.id}"
    assert_response :success
  end

  test 'new product admin' do
       
    sign_in users(:user_admin)
    get "/products/new"
    assert_response :success  
  end

  test 'edit product admin' do
    sign_in users(:user_admin)
    p = products(:one)
    get edit_product_url(p.id)
    assert_response :success
  end

  test 'edit product client' do
    sign_in users(:user_client)
    p = products(:one)
    get edit_product_url(p.id)
    assert_response :redirect
  end

  test 'delete product admin' do
    sign_in users(:user_admin)
    @product = products(:one)
    delete product_url(@product)
    @product.reload.status
    
    assert_equal 0, @product.status
    assert_response :redirect
  end

  test 'delete product client' do
    sign_in users(:user_client)
    @product = products(:one)
    delete product_url(@product)
    @product.reload.status
    
    assert_response :redirect
  end

 
end
