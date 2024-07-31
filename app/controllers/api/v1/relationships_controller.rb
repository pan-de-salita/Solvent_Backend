# frozen_string_literal: true

module Api
  module V1
    class RelationshipsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_relationship, only: :destroy

      # POST api/v1/relationships
      def create
        other_user = User.find_by(id: follow_params[:followed_id])

        if current_user.follow(other_user)
          relationship = current_user.active_relationships.last

          render json: {
            status: { code: 201, message: 'Created relationship successfully.' },
            data: { new_relationship: RelationshipSerializer.new(relationship)
                                                            .serializable_hash[:data][:attributes] }
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
        if current_user.unfollow(@relationship.followed)
          render json: {
            status: { code: 200, message: 'Deleted relationship successfully.' },
            data: { deleted_relationship: RelationshipSerializer.new(@relationship)
                                                                .serializable_hash[:data][:attributes] }

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

      def set_relationship
        @relationship = Relationship.includes(:follower, :followed).find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: {
          status: { code: 404, message: e }
        }, status: :not_found
      end

      def follow_params
        params.require(:relationship).permit :followed_id
      end
    end
  end
end
