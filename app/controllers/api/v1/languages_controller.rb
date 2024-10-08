# frozen_string_literal: true

module Api
  module V1
    class LanguagesController < ApplicationController
      before_action :set_language, except: :index

      # GET api/v1/langauges
      def index
        languages = Language.all

        render json: {
          status: { code: 200, message: 'Got all languages successfully.' },
          data: {
            languages: LanguageSerializer.new(languages)
                                         .serializable_hash[:data]
                                         .map { |data| data[:attributes] }
          }
        }, status: :ok
      end

      # GET api/v1/languages/:id
      def show
        # Error raised via set_language in case of no id match.
        render json: {
          status: { code: 200, message: "Got languge #{@language.name} successfully." },
          data: { language: LanguageSerializer.new(@language)
                                              .serializable_hash[:data][:attributes] }
        }, status: :ok
      end

      private

      def set_language
        @language = Language.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: {
          status: { code: 404, message: e }
        }, status: :not_found
      end
    end
  end
end
