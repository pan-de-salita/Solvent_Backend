# frozen_string_literal: true

module Api
  module V1
    class PuzzlesController < ApplicationController
      before_action :set_puzzle, except: %i[index create]
      before_action :authenticate_user!, except: %i[index show]

      # GET api/v1/puzzles
      def index
        puzzles = Puzzle.recent.includes(:creator, :solutions)

        render json: {
          status: { code: 200, message: 'Got all puzzles successfully.' },
          data: {
            puzzles: PuzzleSerializer.new(puzzles).serializable_hash[:data].map { |data| data[:attributes] }
          }
        }, status: :ok
      end

      # POST api/v1/puzzles
      def create
        puzzle = Puzzle.new(puzzle_params)

        if puzzle.save
          render json: {
            status: { code: 201, message: 'Created puzzle successfully.' },
            data: PuzzleSerializer.new(puzzle).serializable_hash[:data][:attributes]
          }, status: :created
        else
          render json: {
            status: {
              code: 422,
              message: "Puzzle couldn't be created successfully. #{puzzle.errors.full_messages.to_sentence}"
            }
          }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: {
          status: { status: 400, message: e }
        }, status: :bad_request
      end

      # GET api/v1/puzzles/:id
      def show
        # Error raised via set_puzzle in case of no id match.
        render json: {
          status: { code: 200, message: 'Got puzzle successfully.' },
          data: PuzzleSerializer.new(@puzzle).serializable_hash[:data][:attributes]
        }, status: :ok
      end

      # PATCH/PUT api/v1/puzzles/:id
      def update
        if current_user_is_puzzle_creator? && @puzzle.update(puzzle_params)
          render json: {
            status: { code: 200, message: 'Updated puzzle successfully.' },
            data: PuzzleSerializer.new(@puzzle).serializable_hash[:data][:attributes]
          }, status: :ok
        else
          render json: {
            status: {
              code: 422,
              message: "Puzzle couldn't be updated successfully. #{@puzzle.errors.full_messages.to_sentence}"
            }
          }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: {
          status: { status: 400, message: e }
        }, status: :bad_request
      end

      # DELETE api/v1/puzzles/:id
      def destroy
        if current_user_is_puzzle_creator? && @puzzle.destroy
          render json: {
            status: { code: 200, message: 'Deleted puzzle successfully.' },
            data: { deleted_puzzle: PuzzleSerializer.new(@puzzle).serializable_hash[:data][:attributes] }
          }, status: :ok
        else
          render json: {
            status: {
              code: 422,
              message: "Puzzle couldn't be deleted successfully. #{@puzzle.errors.full_messages.to_sentence}"
            }
          }, status: :unprocessable_entity
        end
      end

      private

      def set_puzzle
        @puzzle = Puzzle.includes(:creator, :solutions).find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: {
          status: { code: 404, message: e }
        }, status: :not_found
      end

      def puzzle_params
        params.require(:puzzle).permit :title, :description, :creator_id, :expected_output
      end

      def current_user_is_puzzle_creator?
        @puzzle.creator == current_user
      end
    end
  end
end
