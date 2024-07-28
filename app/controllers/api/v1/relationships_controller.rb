# frozen_string_literal: true

module Api
  module V1
    class RelationshipsController < ApplicationController
      before_action :authenticate_user!

      # POST api/v1/relationships/:followed_id
      def create
        other_user = User.find_by(id: follow_params[:followed_id])

        if current_user.follow(other_user)
          render json: {
            status: { code: 201, message: 'Created relationship successfully.' },
            data: RelationshipSerializer.new(relationship).serializable_hash[:data][:attributes]
          }, status: :created
        else
          render json: {
            status: {
              code: 422,
              message: "Relationship couldn't be created successfully. #{relationship.errors.full_messages.to_sentence}."
            }
          }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: {
          status: { status: 400, message: e }
        }, status: :bad_request
      end

      # DELETE api/v1/relationships/:id
      def destroy
        other_user = Relationship.find(unfollow_params[:id]).followed

        if current_user.unfollow(other_user)
          render json: {
            status: { code: 200, message: 'Deleted relationship successfully.' },
            data: { deleted_relationship: RelationshipSerializer.new(@relationship).serializable_hash[:data][:attributes] }
          }, status: :ok
        else
          render json: {
            status: {
              code: 422,
              message: "Relationship couldn't be deleted successfully. #{@relationship.errors.full_messages.to_sentence}."
            }
          }, status: :unprocessable_entity
        end
      end

      private

      def follow_params
        params.require(:relationship).permit :followed_id
      end

      def unfollow_params
        params.require(:relationship).permit :id
      end
    end
  end
end
