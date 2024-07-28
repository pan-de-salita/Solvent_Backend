# frozen_string_literal: true

module Api
  module V1
    class SolutionsController < ApplicationController
      before_action :set_solution, except: %i[index create]
      before_action :authenticate_user!

      # GET api/v1/solutions
      def index
        solutions = current_user.solutions

        render json: {
          status: { code: 200, message: 'Got all solutions successfully.' },
          data: {
            solution_count: solutions.count,
            solutions: SolutionSerializer.new(solutions).serializable_hash[:data].map { |data| data[:attributes] }
          }
        }, status: :ok
      end

      # POST api/v1/solutions
      def create
        solution = Solution.new(solution_params)

        if solution.save
          render json: {
            status: { code: 201, message: 'Created solution successfully.' },
            data: SolutionSerializer.new(solution).serializable_hash[:data][:attributes]
          }, status: :created
        else
          render json: {
            status: {
              code: 422,
              message: "Solution couldn't be created successfully. #{solution.errors.full_messages.to_sentence}."
            }
          }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: {
          status: { status: 400, message: e }
        }, status: :bad_request
      end

      # GET api/v1/solutions/:id
      def show
        # Error raised via set_solution in case of no id match.
        render json: {
          status: { code: 200, message: 'Got solution successfully.' },
          data: SolutionSerializer.new(@solution).serializable_hash[:data][:attributes]
        }, status: :ok
      end

      # PATCH/PUT api/v1/solutions/:id
      def update
        if @solution.update(solution_params)
          render json: {
            status: { code: 200, message: 'Updated solution successfully.' },
            data: SolutionSerializer.new(@solution).serializable_hash[:data][:attributes]
          }, status: :ok
        else
          render json: {
            status: {
              code: 422,
              message: "Solution couldn't be updated successfully. #{@solution.errors.full_messages.to_sentence}."
            }
          }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: {
          status: { status: 400, message: e }
        }, status: :bad_request
      end

      # DELETE api/v1/solutions/:id
      def destroy
        if @solution.destroy
          render json: {
            status: { code: 200, message: 'Deleted solution successfully.' },
            data: { deleted_solution: SolutionSerializer.new(@solution).serializable_hash[:data][:attributes] }
          }, status: :ok
        else
          render json: {
            status: {
              code: 422,
              message: "Solution couldn't be deleted successfully. #{@solution.errors.full_messages.to_sentence}."
            }
          }, status: :unprocessable_entity
        end
      end

      private

      def set_solution
        @solution = current_user.solutions.where(id: params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: {
          status: { code: 404, message: e }
        }, status: :not_found
      end

      def solution_params
        params.require(:solution).permit :source_code, :language_id, :puzzle_id, :user_id
      end
    end
  end
end
