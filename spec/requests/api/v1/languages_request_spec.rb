require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Languages Requests', type: :request do
  let!(:languages) do
    %w[Ruby TypeScript Racket].each { |lang| create :language, name: lang }
  end
  let!(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }

  describe 'GET /api/v1/langauges' do
    it 'returns all languages' do
      get('/api/v1/languages', headers:)
      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(response_data['languages']).to be_kind_of(Array)
      expect(response_data['languages'].map { |lang| lang['id'] }).to eq(Language.all.map(&:id))
    end
  end

  describe 'GET /api/v1/langauges/:id' do
    it 'returns the specified languages' do
      first_language = Language.first
      get("/api/v1/languages/#{first_language.id}", headers:)
      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(response_data['language']).to be_kind_of(Hash)
      expect(response_data['language']['id']).to eq(first_language.id)
    end
  end
end
