require 'bcrypt'
require 'securerandom'

class EmployersController < ApplicationController
  def register
    @email = params[:email]
    @username = params[:username]
    @password = params[:password]

    if @password.length >= 8
      @password_hash = BCrypt::Password.create(@password)
      @registration_token = SecureRandom.uuid

      @employer = Employer.create(email: @email, username: @username, password_hash: @password_hash, registration_token: @registration_token)

      if @employer.save
        employer_with_token(@employer)
      else
        respond_to do |format|
          format.json { render status: 301, json: @employer.errors.messages.to_json }
        end
      end
    else
      password_too_short
    end
  end

  def sign_in
    @email = params[:email]
    @password = params[:password]

    @employer = Employer.find_by(email: @email)
    if @employer
      password_hash = BCrypt::Password.new(@employer.password_hash)
      if password_hash == @password
        employer_with_token(@employer)
      else
        bad_login
      end
    else
      bad_login
    end
  end

  def index
    validate_jwt_token_and_respond(Employer) do |id|
      respond_to do |format|
        format.json { render status: 200, json: Employer.find(id), except: ["password_hash"] }
      end
    end
  end

  private

  def employer_with_token(employer)
    respond_to do |format|
      employer_json = employer.attributes.merge(token: generate_jwt_token(employer.id))
      format.json { render status: 201, json: employer_json, except: ["password_hash"] }
    end
  end
end
