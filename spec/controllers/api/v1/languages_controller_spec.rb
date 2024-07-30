require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe Api::V1::LanguagesController, type: :controller do
  let!(:languages) do
    %w[Ruby TypeScript Racket].each { |lang| create :language, name: lang }
  end

  describe 'GET api/v1/langauges' do
    it 'returns all languages' do
      get :index

      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(response_data['languages']).to be_kind_of(Array)
      expect(response_data['languages'].map { |lang| lang['id'] }).to eq(Language.all.map(&:id))
    end
  end

  describe 'GET api/v1/langauges/:id' do
    it 'returns the specified languages' do
      first_language = Language.first
      get :show, params: { id: first_language.id }

      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(response_data['language']).to be_kind_of(Hash)
      expect(response_data['language']['id']).to eq(first_language.id)
    end
  end
end
