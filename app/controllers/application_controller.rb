class ApplicationController < ActionController::Base
    before_action :authenticate 

    def user_exists?(user_params)
      User.where(email: user_params[:email]).blank?
    end

    def current_user
      if auth_present?
        user = User.find(auth["user"])
        if user
          @current_user ||= user
        end
      end
    end

    def authenticate(user_params)
      unless user_exists?(user_params)
        User.new(user_params).save()
      end

      render json: {error: "unauthorized"}, status: 401 
        unless logged_in?
    end

    private
    #https://www.thegreatcodeadventure.com/jwt-auth-in-rails-from-scratch/
      def token
        request.env["HTTP_AUTHORIZATION"].scan(/Bearer 
          (.*)$/).flatten.last
      end

      def auth
        JWToken.decode(token)
      end

      def has_token?
        !!request.env.fetch("HTTP_AUTHORIZATION", 
          "").scan(/Bearer/).flatten.first
      end

  end  
end
