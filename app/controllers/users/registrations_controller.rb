# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  respond_to :json
  before_action :configure_sign_up_params, only: :create

  private

  def respond_with(resource, _opts = {})
    if request.method == 'POST' && resource.persisted?
      render json: {
        status: { code: 201, message: 'Signed up sucessfully.' },
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }, status: :created
    elsif request.method == 'DELETE'
      render json: {
        status: { code: 200, message: 'Account deleted successfully.' },
        data: { deleted_user: UserSerializer.new(resource).serializable_hash[:data][:attributes] }
      }, status: :ok
    else
      render json: {
        status: {
          code: 422,
          message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}."
        }
      }, status: :unprocessable_entity
    end
  end

  def configure_sign_up_params
    permitted_sign_up_param_keys = %i[username email password password_confirmation preferred_languages]
    devise_parameter_sanitizer.permit(:sign_up, keys: permitted_sign_up_param_keys)
  end
end
