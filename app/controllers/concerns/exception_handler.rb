module ExceptionHandler
  extend ActiveSupport::Concern

  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  class VerificationError < StandardError; end

  included do

    rescue_from ExceptionHandler::DecodeError do |_error|
      send_response 'Auth token unreadable.'
    end

    rescue_from ExceptionHandler::ExpiredSignature do |_error|
      send_response 'Token has expired.'
    end

    rescue_from ExceptionHandler::VerificationError do |_error|
      send_response 'Invalid token.'
    end

  end

  private

  def send_response(message)
    render json: {
      message: message, status: 401
    }, status: :unauthorized
  end

end
