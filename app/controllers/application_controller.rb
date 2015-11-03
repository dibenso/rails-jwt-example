require 'jwt'

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::ImplicitRender

  def generate_jwt_token(id)
    exp = Time.now.to_i + 4 * 3600
    payload = { exp: exp, id: id }

    JWT.encode payload, Secret.secret, 'HS256'
  end

  def validate_jwt_token(token)
    begin
      decoded_token = JWT.decode(token, Secret.secret, true, { algorithm: 'HS256' })
      rescue JWT::VerificationError
        return false
    end
    decoded_token[0]["id"]
  end

  def bad_login
    respond_to do |format|
      format.json { render status: 401, json: {error: 'Incorrect login.'} }
    end
  end

  def password_too_short
    respond_to do |format|
      format.json { render status: 301, json: {error: 'Password must be greater than or equal to 8 characters long.'} }
    end
  end

  def handle_incorrect_token
    respond_to do |format|
      format.json { render status: 401, json: {error: 'Incorrect token.'} }
    end
  end

  def validate_jwt_token_and_respond(klass, &block)
    @token = request.headers["Authorization"]

    id = validate_jwt_token(@token)
    if id
      if klass.find_by(id: id)
        block.call(id)
      else
        handle_incorrect_token
      end
    else
      handle_incorrect_token
    end
  end
end
