# frozen_string_literal: true

require 'jwtoken'

class ApplicationController < ActionController::Base
  include ExceptionHandler

  before_action :check_auth

  def check_auth
    unless (token_present? || token_on_path?) && valid_token?
      render json: {
        message: 'You need request a token before go ahead.',
        status: 401
      }, status: :unauthorized
    end
  end

  private

  def valid_token?
    !JWToken.decode(token).blank?
  end

  def token_on_path?
    !params[:t].blank?
  end

  def token_present?
    auth_header = request.env.fetch 'HTTP_AUTHORIZATION', ''
    !auth_header.scan(/Bearer/).flatten.first.blank?
  end

  def token
    if token_present?
      request.env['HTTP_AUTHORIZATION'].scan(/Bearer (.*)$/).flatten.last
    else
      params[:t]
    end
  end
end
