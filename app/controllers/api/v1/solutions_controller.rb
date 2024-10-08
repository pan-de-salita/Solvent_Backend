# frozen_string_literal: true

module Api
  module V1
    class SolutionsController < ApplicationController
      before_action :set_puzzle
      before_action :set_solution, except: %i[index create]
      before_action :authenticate_user!
      before_action :authorize_solution_creator, only: %i[show update destroy]

      # GET api/v1/puzzles/:puzzle_id/solutions
      def index
        solutions = @puzzle.solutions.recent.where(user: current_user)

        render json: {
          status: { code: 200, message: "Got all solutions to puzzle '#{@puzzle.title}' successfully." },
          data: { all_solutions: SolutionSerializer.new(solutions)
                                                   .serializable_hash[:data]
                                                   .map { |data| data[:attributes] } }
        }, status: :ok
      end

      # POST api/v1/puzzles/:puzzle_id/solutions
      def create
        solution = @puzzle.solutions.build(solution_params.merge({ user_id: current_user.id }))

        if solution.save
          render json: {
            status: { code: 201, message: 'Created solution successfully.' },
            data: { new_solution: SolutionSerializer.new(solution)
                                                    .serializable_hash[:data][:attributes] }
          }, status: :created
        else
          render json: {
            status: {
              code: 422,
              message: "Solution couldn't be created successfully. #{solution.errors.full_messages.to_sentence}"
            }
          }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: {
          status: { status: 400, message: e }
        }, status: :bad_request
      end

      # GET api/v1/puzzles/:puzzle_id/solutions/:id
      def show
        unless current_user_is_solution_creator?
          render json: {
            status: {
              code: 403,
              message: 'You are not authorized to view this solution.'
            }
          }, status: :forbidden
          return
        end

        # Error raised via set_solution in case of no id match.
        render json: {
          status: { code: 200, message: 'Got solution successfully.' },
          data: { solution: SolutionSerializer.new(@solution)
                                              .serializable_hash[:data][:attributes] }
        }, status: :ok
      end

      # PATCH/PUT api/v1/puzzles/:puzzle_id/solutions/:id
      def update
        if @solution.update(solution_params)
          render json: {
            status: { code: 200, message: 'Updated solution successfully.' },
            data: { updated_solution: SolutionSerializer.new(@solution)
                                                        .serializable_hash[:data][:attributes] }
          }, status: :ok
        else
          render json: {
            status: {
              code: 422,
              message: "Solution couldn't be updated successfully. #{@solution.errors.full_messages.to_sentence}"
            }
          }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: {
          status: { status: 400, message: e }
        }, status: :bad_request
      end

      # DELETE api/v1/puzzles/:puzzles_id/solutions/:id
      def destroy
        if @solution.destroy
          render json: {
            status: { code: 200, message: 'Deleted solution successfully.' },
            data: { deleted_solution: SolutionSerializer.new(@solution)
                                                        .serializable_hash[:data][:attributes] }
          }, status: :ok
        else
          render json: {
            status: {
              code: 422,
              message: "Solution couldn't be deleted successfully. #{@solution.errors.full_messages.to_sentence}"
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
        @solution = @puzzle.solutions.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: {
          status: { code: 404, message: e }
        }, status: :not_found
      end

      def solution_params
        params.require(:solution).permit :source_code, :language_id
      end

      def authorize_solution_creator
        return if current_user_is_solution_creator?

        render json: {
          status: {
            code: 401,
            message: "You aren't authorized to complete the action."
          }
        }, status: :unauthorized
      end

      def current_user_is_solution_creator?
        @solution.user == current_user
      end
    end
  end
end
