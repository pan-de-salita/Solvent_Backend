# frozen_string_literal: true

module Api
  module V1
    class CurrentUserController < ApplicationController
      before_action :authenticate_user!

      # GET api/v1/current_user
      def index
        render json: UserSerializer.new(current_user).serializable_hash[:data][:attributes], status: :ok
      end
    end
  end
end
