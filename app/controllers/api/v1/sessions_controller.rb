module API
  module V1
    class SessionsController < ApplicationController
      skip_before_action :verify_authenticity_token
      respond_to :json
      KEY = Rails.application.secrets.secret_key_base.to_s
      
      def create
        @user = User.find_by(email: params[:email])
        
        if @user.nil?
          head(:unathorized)
         
        else
          if @user.valid_password?(params[:password])
            jwt = JWT.encode(
              { user_id: @user.id, user_email: @user.email },
              KEY,
              'HS256'
            )
            request.headers[:token] = jwt
            render json: { status: 'OK', message: 'Valid credenttials', data: jwt }
          end
        end
      end

      def index
        data = request.headers[:token]
        decoded_token = JWT.decode data, nil, false
        user_id = decoded_token[0]['user_id']

        @user = User.find(user_id)
        render json: {  user: @user }
      end

    end
  end
end