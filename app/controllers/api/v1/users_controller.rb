# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user

      # GET api/v1/users/:id
      def show
        # Error raised via set_puzzle in case of no id match.
        render json: {
          status: { code: 200, message: 'Got user successfully.' },
          data: OtherUserSerializer.new(@user).serializable_hash[:data][:attributes]
        }, status: :ok
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: {
          status: { code: 404, message: e }
        }, status: :not_found
      end
    end
  end
end
