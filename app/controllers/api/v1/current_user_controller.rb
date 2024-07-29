# frozen_string_literal: true

module Api
  module V1
    class CurrentUserController < ApplicationController
      before_action :authenticate_user!

      # GET api/v1/current_user
      def index
        user = User.includes(:following, :followers, :languages, :puzzles, :solutions).find(current_user.id)

        render json: {
          status: { code: 200, message: "Got all of #{current_user.username}'s followers successfully." },
          data: UserSerializer.new(user).serializable_hash[:data][:attributes]
        }, status: :ok
      end

      # GET api/v1/current_user/followers
      def followers
        render json: {
          status: { code: 200, message: "Got all of #{current_user.username}'s followers successfully." },
          data: { followers: current_users.followers }
        }, status: :ok
      end

      # GET api/v1/current_user/following
      def following
        render json: {
          status: { code: 200, message: "Got all of #{current_user.username}'s following successfully." },
          data: { following: current_users.following }
        }, status: :ok
      end

      # GET api/v1/current_user/completed_solutions
      def completed_solutions
        solutions = current_user.solutions

        render json: {
          status: { code: 200, message: "Got all of #{current_user.username}'s completed solutions successfully." },
          data: {
            solutions: SolutionSerializer.new(solutions).serializable_hash[:data].map do |data|
                         data[:attributes]
                       end
          }
        }, status: :ok
      end

      # GET api/v1/current_user/created_puzzles
      def created_puzzles
        puzzles = current_user.puzzles

        render json: {
          status: { code: 200, message: "Got all of #{current_user.username}'s created puzzles successfully." },
          data: {
            solutions: PuzzleSerializer.new(puzzles).serializable_hash[:data].map do |data|
                         data[:attributes]
                       end
          }
        }, status: :ok
      end

      # GET api/v1/current_user/solved_puzzles
      def solved_puzzles
        puzzles = current_user.solutions.map(&:puzzle).uniq

        render json: {
          status: { code: 200, message: "Got all of #{current_user.username}'s solved_puzzles successfully." },
          data: {
            solutions: PuzzleSerializer.new(puzzles).serializable_hash[:data].map do |data|
                         data[:attributes]
                       end
          }
        }, status: :ok
      end
    end
  end
end
