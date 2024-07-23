# frozen_string_literal: true

module Api
  module V1
    class PuzzlesController < ApplicationController
      before_action :set_puzzle, except: %i[index create]

      # POST api/v1/puzzles
      def index
        puzzles = Puzzle.all

        render json: {
          status: { code: 200, message: 'Retrieved all puzzles' },
          data: {
            puzzle_count: puzzles.count,
            puzzles: PuzzleSerializer.new(puzzles).serializable_hash[:data].map { |data| data[:attributes] }
          }
        }, status: :ok
      end

      # POST api/v1/puzzles
      def create
        puzzle = Puzzle.new(puzzle_params)

        if puzzle.save
          render json: {
            status: { code: 201, message: 'Puzzle creation successful' },
            data: PuzzleSerializer.new(puzzle).serializable_hash[:data][:attributes]
          }, status: :created
        else
          render json: {
            status: { code: 422, message: 'Puzzle creation unsuccessful' },
            data: puzzle.errors.full_messages
          }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: {
          status: { status: 400, message: e },
          data: nil
        }, status: :bad_request
      end

      # GET api/v1/puzzles/:id
      def show
        # Error raised via set_puzzle in case of no puzzle id match.
        render json: {
          status: { code: 200, message: 'Puzzle found' },
          data: PuzzleSerializer.new(@puzzle).serializable_hash[:data][:attributes]
        }, status: :ok
      end

      # PATCH/PUT api/v1/puzzles/:id
      def update
        if @puzzle.update(puzzle_params)
          render json: {
            status: { code: 200, message: 'Puzzle update successful' },
            data: PuzzleSerializer.new(@puzzle).serializable_hash[:data][:attributes]
          }, status: :ok
        else
          render json: {
            status: { code: 422, message: 'Puzzle update unsuccessful' },
            data: @puzzle.errors.full_messages
          }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: {
          status: { status: 400, message: e },
          data: nil
        }, status: :bad_request
      end

      # DELETE api/v1/puzzles/:id
      def destroy
        if @puzzle.destroy
          render json: {
            status: { code: 200, message: 'Puzzle deletion successful' },
            data: { deleted_puzzle: PuzzleSerializer.new(@puzzle).serializable_hash[:data][:attributes] }
          }, status: :ok
        else
          render json: {
            status: { code: 422, message: 'Puzzle deletion unsuccessful' },
            data: @puzzle.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def set_puzzle
        @puzzle = Puzzle.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: {
          status: { code: 404, message: e },
          data: nil
        }, status: :not_found
      end

      def puzzle_params
        params.require(:puzzle).permit :title, :description, :start_date, :end_date
      end
    end
  end
end
