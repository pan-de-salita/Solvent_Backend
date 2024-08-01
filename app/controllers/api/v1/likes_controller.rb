# frozen_string_literal: true

module Api
  module V1
    class LikesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_puzzle
      before_action :set_solution
      before_action :set_like, only: :destroy
      before_action :authorize_like_creator, only: :destroy

      # POST api/v1/puzzles/:puzzle_id/solutions/:solution_id/likes
      def create
        like = @solution.likes.new(user_id: current_user.id)

        if like.save
          render json: {
            status: { code: 201, message: 'Created like successfully.' },
            data: { new_like: LikeSerializer.new(like)
                                            .serializable_hash[:data][:attributes] }
          }, status: :created
        else
          render json: {
            status: {
              code: 422,
              message: "Like couldn't be created successfully. #{relationship.errors.full_messages.to_sentence}."
            }
          }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: {
          status: { status: 400, message: e }
        }, status: :bad_request
      end

      # DELETE api/v1/puzzles/:puzzle_id/solutions/:solution_id/likes/:id
      def destroy
        if @like.destroy
          render json: {
            status: { code: 200, message: 'Deleted like successfully.' },
            data: { deleted_like: LikeSerializer.new(@like)
                                                .serializable_hash[:data][:attributes] }

          }, status: :ok
        else
          render json: {
            status: {
              code: 422,
              message: "Like couldn't be deleted successfully. #{@relationship.errors.full_messages.to_sentence}."
            }
          }, status: :unprocessable_entity
        end
      end

      private

      def set_puzzle
        @puzzle = Puzzle.includes(:creator, :solutions).find(params[:puzzle_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: {
          status: { code: 404, message: e.message }
        }, status: :not_found
      end

      def set_solution
        @solution = @puzzle.solutions.find(params[:solution_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: {
          status: { code: 404, message: e }
        }, status: :not_found
      end

      def set_like
        @like = @solution.likes.find(params[:id])
      end

      def authorize_like_creator
        return if current_user_is_like_creator?

        render json: {
          status: {
            code: 401,
            message: "You aren't authorized to complete the action."
          }
        }, status: :unauthorized
      end

      def current_user_is_like_creator?
        @like.user == current_user
      end
    end
  end
end
