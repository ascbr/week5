module API
  module V1
    class SessionsController < ApplicationController
      skip_before_action :verify_authenticity_token
      respond_to :json
      KEY = Rails.application.secrets.secret_key_base.to_s
      def create
        @user = User.find_by(email: params[:email])
        if @user.nil?
          render json: {message: 'user not found'}, status: :unathorized
        elsif @user.valid_password?(params[:password])
            jwt = JWT.encode(
              { user_id: @user.id, user_email: @user.email, exp: (Time.now + 2.week).to_i },
              KEY,
              'HS256'
            )
            request.headers[:token] = jwt
            render json: { status: 'OK', message: 'Valid credenttials', data: jwt }, status: :ok
        else
            render json: {message: 'invalid credentials'}, status: :unathorized
        end
      end

      def index
        puts KEY
        data = request.headers[:token]
        begin
          decoded_token = JWT.decode data, KEY, true, { algorithm: 'HS256'}
          user_id = decoded_token[0]['user_id']
          @user = User.find(user_id)
          render json: { user: @user }
        rescue JWT::VerificationError
          render json: { info: 'token expired' }, status: :unathorized
        rescue
          render json: { info: 'user not found' }, status: :not_found
        end
      end
    end
  end
end