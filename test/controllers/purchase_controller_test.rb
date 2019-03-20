require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test 'index response' do
    get products_url
    assert_response :success
  end

  test 'purchase response' do
    @purchase = purchases(:one)

    post new_purchases_url, params: { purchase: {purchase_id: @purchase.id, total: 100}  }
    assert_response :redirect
  end

  test 'purchase redirect' do
    @purchase = purchases(:one)

    post new_purchases_url, params: { purchase: {purchase_id: @purchase.id, total: 100}  }
    assert_redirected_to products_url
  end

  test 'purchase redirect orders' do
    @purchase = purchases(:two)

    post new_purchases_url, params: { purchase: {purchase_id: @purchase.id, total: 100}  }
    assert_redirected_to orders_url
  end


end