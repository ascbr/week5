require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test 'index response' do
    get products_url
    assert_response :success
  end

end