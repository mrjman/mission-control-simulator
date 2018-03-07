class UsersController < ApplicationController
  before_action :authenticate_access_token!, only: [:create, :forgottenpass]
  before_action :authenticate_user_from_access_token!, only: [:show, :update, :destroy]

  def token
    @token_params = token_params
    @token = Token.find_by(@token_params.slice(:client_secret).merge(user_id: nil))

    success = @token.present?
    if @token_params[:grant_type] == 'password'
      user = User.find_by(email: @token_params[:username])&.authenticate(@token_params[:password])

      if user.present?
        @token = user&.build_token(@token_params.slice(:client_id, :client_secret, :expires_in))
      end

      success &= user.present? && user.save
    elsif @token_params[:username].blank? && @token_params[:password].blank?
      success &= @token_params[:grant_type] == 'client_credentials'
    else
      success = false
    end

    if success
      render json: @token.as_json, status: :ok
    else
      render(
        json: {
          "error": "invalid_grant",
          "error_description": "Bad credentials"
        },
        status: :bad_request
      )
    end
  end

  def show
    if current_user.present?
      render json: current_user.as_json, status: :ok
    else
      head :bad_request
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      head :created
    else
      head :bad_request
    end
  end

  def update
    if current_user&.update_attributes(user_params)
      head :ok
    else
      head :bad_request
    end
  end

  def forgottenpass
    @user = User.find_by(email: forgotten_password_params[:pwdUserId])

    if @user.present?
      head :ok
    else
      render(
        json: {
          "errors": [
            "message": "Cannot find user with uid '#{params[:pwdUserId]}'",
            "type": "UnknownIdentifierError"
          ]
        },
        status: :bad_request
      )
    end
  end

  def destroy
    current_user.destroy
    head :no_content
  end

  def current_user
    @current_user
  end

  private

  def authenticate_access_token!
    authenticate_with_http_token do |token, _|
      @token = Token.find_by(access_token: token)
    end

    head :unauthorized if @token.blank?
  end

  def authenticate_user_from_access_token!
    authenticate_with_http_token do |token, _|
      @token = Token.find_by(access_token: token)
      @current_user = @token&.user
    end

    if @current_user.blank? || @token.expired?
      render(
        json: {
          "errors": [
            {
              "type": "InvalidTokenError",
              "message": "Access token expired: #{@token&.access_token}"
            }
          ]
        },
        status: :unauthorized
      )
    end
  end

  def token_params
    params.permit(
      :client_id,
      :client_secret,
      :grant_type,
      :username,
      :password,
      :expires_in
    )
  end

  def user_params
    params.transform_keys do |key|
      key = 'email' if key.to_s == 'uid'
      key.to_s.underscore
    end.permit(
      :email,
      :password,
      :first_name,
      :last_name,
      :city,
      :gender,
      :weight,
      :height
    )
  end

  def forgotten_password_params
    params.permit(:pwdUserId)
  end
end
