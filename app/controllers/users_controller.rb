require 'bcrypt'

class UsersController < ApplicationController
  def register
    @email = params[:email]
    @username = params[:username]
    @password = params[:password]
    @registration_token = params[:registration_token]

    @employer = Employer.find_by(registration_token: @registration_token)

    if @employer
      if @password.length >= 8
        @password_hash = BCrypt::Password.create(@password)

        @user = User.create(email: @email, username: @username, password_hash: @password_hash, employer_id: @employer.id)

        if @user.save
          user_with_token(@user)
        else
          respond_to do |format|
            format.json { render status: 301, json: @user.errors.messages.to_json }
          end
        end
      else
        password_too_short
      end
    else
      respond_to do |format|
        format.json { render status: 401, json: {error: 'Incorrect registration token'} }
      end
    end
  end

  def sign_in
    @email = params[:email]
    @password = params[:password]

    @user = User.find_by(email: @email)
    if @user
      password_hash = BCrypt::Password.new(@user.password_hash)
      if password_hash == @password
        user_with_token(@user)
      else
        bad_login
      end
    else
      bad_login
    end
  end

  def index
    validate_jwt_token_and_respond(User) do |id|
      respond_to do |format|
        format.json { render status: 200, json: User.find(id), except: ["password_hash"] }
      end
    end
  end

  private

  def user_with_token(user)
    respond_to do |format|
      user_json = user.attributes.merge(token: generate_jwt_token(user.id))
      format.json { render status: 201, json: user_json, except: ["password_hash"] }
    end
  end
end
