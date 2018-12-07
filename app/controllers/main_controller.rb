require 'jwtoken'

class MainController < ApplicationController
  skip_before_action :check_auth

  # GET /
  def index; end

  # POST /create
  def create
    user = User.where(email: auth_params[:email])

    if user.blank?
      user = User.new(auth_params)

      render json: user.errors, status: :unprocessable_entity unless user.save
      user = [user]
    end

    jwt = JWToken.encode(user: user.map(&:_id).first.to_s)
    render json: { token: jwt }
  end

  private

  def auth_params
    params.require(:user).permit(:email, :password)
  end
end
