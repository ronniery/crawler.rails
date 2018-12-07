# //-> Doc: https://www.rubydoc.info/github/jwt/ruby-jwt/JWT
class JWToken

  def self.encode(payload, exp = 2.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, APP_CONFIG['secret_key_base'])
  end

  def self.decode(token)
    body = JWT.decode(token, APP_CONFIG['secret_key_base'])[0]
    HashWithIndifferentAccess.new body

  rescue JWT::VerificationError, JWT::VerificationError => e
    raise ExceptionHandler::VerificationError, e.message
  rescue JWT::ExpiredSignature, JWT::ExpiredSignature => e
    raise ExceptionHandler::ExpiredSignature, e.message
  rescue JWT::DecodeError, JWT::DecodeError => e
    raise ExceptionHandler::DecodeError, e.message
  end

end
