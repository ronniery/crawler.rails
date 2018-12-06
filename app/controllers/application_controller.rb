class ApplicationController < ActionController::API
  before_action :check_auth

  def check_auth
    unless has_token?
      render json: {error: "unauthorized"}, status: 401
    end
  end

  private

    def has_token_path?
      request.env["HTTP_AUTHORIZATION"].scan(/Bearer 
        (.*)$/).flatten.last
    end

    def has_token?
      !!request.env.fetch("HTTP_AUTHORIZATION", 
        "").scan(/Bearer/).flatten.first
    end
end
