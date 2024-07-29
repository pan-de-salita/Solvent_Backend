# frozen_string_literal: true

module Api
  module V1
    class CurrentUserController < ApplicationController
      before_action :authenticate_user!

      # GET api/v1/current_user
      def index
        user = User.includes(:following, :followers, :languages, :puzzles, :solutions).find(current_user.id)

        render json: UserSerializer.new(user).serializable_hash[:data][:attributes], status: :ok
      end
    end
  end
end
