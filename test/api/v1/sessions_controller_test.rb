module API
  module V1
    class SessionsControllerTest < ActionDispatch::IntegrationTest

     
      test 'authentication right credentials' do
        user = users(:user_admin)
        post api_v1_sessions_url params: {email: user.email, password: '123456'}
        assert_response :success
      end

      test 'authentication wrong email' do
        post api_v1_sessions_url params: {email: 'email@wrong.com', password: '123456'}
        assert_response 500
      end

      test 'authentication wrong password' do
        user = users(:user_admin)
        post api_v1_sessions_url params: {email: user.email, password: '1234536'}
        assert_response 500
      end

      test 'profile right token' do
        user = users(:user_admin)
        post api_v1_sessions_url, params: {email: user.email, password: '123456'}
        #puts response.header[:token]
        get api_v1_sessions_url, headers: {token: response.header[:token]}
        assert_response :success
      end

      test 'profile no token' do
        user = users(:user_admin)
        post api_v1_sessions_url, params: {email: user.email, password: '123e456'}
        get api_v1_sessions_url, headers: {token: response.header[:token]}
        assert_response :not_found
      end

      test 'profile no token message' do
        user = users(:user_admin)
        post api_v1_sessions_url, params: {email: user.email, password: '123e456'}
        get api_v1_sessions_url, headers: {token: response.header[:token]}
        
        assert_equal '{"info":"user not found"}', response.body
      end

    end
  end
end