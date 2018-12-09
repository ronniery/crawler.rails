require 'jwtoken'

# MainController
#
# The main controller creates the entry point of the app, enabling the user create a token with his data
# to access the others endpoints.
#
class MainController < ApplicationController
  # Ignores the token check process
  skip_before_action :check_auth

  # GET /
  def index; end

  # POST /create
  def create
    # Search user using his email
    user = User.where(email: auth_params[:email])

    # No user?
    if user.blank?
      # Save the current user
      user = User.new(auth_params)

      # If problems tell the user and send status unprocessable
      render json: user.errors, status: :unprocessable_entity unless user.save
      # Otherwise wrap it inside an array
      user = [user]
    end

    # Now maps the response getting the id of user (that now is already inside db) and generates a token
    jwt = JWToken.encode(id: user.map(&:_id).first.to_s)
    # Send back to user the valid token that will expires in 2 hours
    render json: { token: jwt }
  end

  private

  # Let only this parameters inside this controller
  def auth_params
    params.require(:user).permit(:email, :password)
  end
end
