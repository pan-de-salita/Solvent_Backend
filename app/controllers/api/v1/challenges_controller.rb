# frozen_string_literal: true

module Api
  module V1
    class ChallengesController < ApplicationController
      before_action :set_challenge, except: %i[index create]

      # POST api/v1/challenges
      def index
        challenges = Challenge.all
        render json: challenges, status: :ok
      end

      # POST api/v1/challenges
      def create
        challenge = Challenge.new(challenge_params)

        if challenge.save
          render json: { message: 'Challenge creation successful', data: challenge }, status: :created
        else
          render json: { message: 'Challenge creation unsuccessful', data: challenge.errors.full_messages },
                 status: :unprocessable_entity
        end
      rescue ActionController::ParameterMissing => e
        render json: { message: e, data: nil }, status: :bad_request
      rescue ActionDispatch::Http::Parameters::ParseError => e
        render json: { message: e, data: nil }, status: :bad_request
      end

      # GET api/v1/challenges/:id
      def show
        render json: { message: 'Challenge found', data: @challenge }, status: :ok
      end

      # PATCH/PUT api/v1/challenges/:id
      def update
        if @challenge.update(challenge_params)
          render json: { message: 'Challenge update successful', data: @challenge }, status: :ok
        else
          render json: { message: 'Challenge update unsuccessful', data: @challenge.errors.full_messages },
                 status: :unprocessable_entity
        end
      rescue ActionController::ParameterMissing => e
        render json: { message: e, data: nil }, status: :bad_request
      end

      # DELETE api/v1/challenges/:id
      def destroy
        if @challenge.destroy
          render json: { message: 'Challenge deletion successful', data: { deleted_challenge: @challenge } },
                 status: :ok
        else
          render json: { message: 'Challenge deletion unsuccessful', data: @challenge.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      private

      def set_challenge
        @challenge = Challenge.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { message: e, data: nil }, status: :not_found
      end

      def challenge_params
        params.require(:challenge).permit :title, :description, :start_date, :end_date
      end
    end
  end
end
