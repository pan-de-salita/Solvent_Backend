# frozen_string_literal: true

module Api
  module V1
    class PuzzlesController < ApplicationController
      before_action :set_puzzle, except: %i[index create show]
      before_action :authenticate_user!, except: %i[index show]

      # GET api/v1/puzzles
      def index
        puzzles = Puzzle.recent.includes(:creator, :solutions)

        render json: {
          status: { code: 200, message: 'Got all puzzles successfully.' },
          data: { all_puzzles: PuzzleSerializer.new(puzzles)
                                               .serializable_hash[:data]
                                               .map { |data| data[:attributes] } }
        }, status: :ok
      end

      # POST api/v1/puzzles
      def create
        puzzle = current_user.puzzles.new(puzzle_params)

        if puzzle.save
          render json: {
            status: { code: 201, message: "Created puzzle '#{puzzle.title}' successfully." },
            data: { new_puzzle: PuzzleSerializer.new(puzzle)
                                                .serializable_hash[:data][:attributes] }
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
        puzzle = Puzzle.find(params[:id])

        if puzzle
          if current_user
            render json: {
              status: { code: 200, message: "Got puzzle '#{puzzle.title}' successfully." },
              data: { puzzle: PuzzleSerializer.new(puzzle)
                                              .serializable_hash[:data][:attributes] }
            }, status: :ok
          else
            puzzle_hash = PuzzleSerializer.new(puzzle)
                                          .serializable_hash[:data][:attributes]
                                          .reject do |attr|
              attr == :solutions
            end

            render json: {
              status: { code: 200, message: "Got puzzle '#{puzzle.title}' successfully." },
              data: { puzzle: puzzle_hash }
            }, status: :ok
          end
        else
          render json: {
            status: {
              code: 404,
              message: "Puzzle with id #{params[:id]} couldn't be found."
            }
          }, status: :not_found

        end
      end

      # PATCH/PUT api/v1/puzzles/:id
      def update
        if @puzzle.update(puzzle_params)
          render json: {
            status: { code: 200, message: "Updated puzzle '#{@puzzle.title}' successfully." },
            data: { updated_puzzle: PuzzleSerializer.new(@puzzle)
                                                    .serializable_hash[:data][:attributes] }
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
        if @puzzle.destroy
          render json: {
            status: { code: 200, message: "Deleted puzzle '#{@puzzle.title}' successfully." },
            data: { deleted_puzzle: PuzzleSerializer.new(@puzzle)
                                                    .serializable_hash[:data][:attributes] }
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
        @puzzle = current_user.puzzles.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: {
          status: { code: 404, message: e }
        }, status: :not_found
      end

      def puzzle_params
        params.require(:puzzle).permit :title, :description, :expected_output
      end
    end
  end
end
