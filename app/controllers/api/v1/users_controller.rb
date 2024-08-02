# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: :show

      # GET api/v1/users
      def index
        users = User.includes(:following, :followers, :languages, :puzzles, :solutions).all

        render json: {
          status: { code: 200, message: 'Got all users successfully.' },
          data: { all_users: OtherUserSerializer.new(users)
                                                .serializable_hash[:data]
                                                .map { |data| data[:attributes] } }
        }, status: :ok
      end

      # GET api/v1/users/:id
      def show
        # Error raised via set_puzzle in case of no id match.
        render json: {
          status: { code: 200, message: "Got user #{@user.username} successfully." },
          data: { user: OtherUserSerializer.new(@user).serializable_hash[:data][:attributes] }
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
