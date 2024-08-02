require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Users Requests', type: :request do
  let!(:user) { create :user }
  let!(:other_user) { create :user }

  describe 'GET /api/v1/users' do
    it 'returns all users' do
      get('/api/v1/users', headers:)
      response_data = JSON.parse(response.body)['data']

      p response_data
      expect(response).to have_http_status(:success)
      expect(response_data['all_users']).to be_kind_of(Array)
      expect(response_data['all_users'].map { |user| user['id'] }).to include(user.id)
      expect(response_data['all_users'].map { |user| user['id'] }).to include(other_user.id)
    end
  end

  describe 'GET /api/v1/users/:id' do
    it 'returns the specified user' do
      get("/api/v1/users/#{user.id}", headers:)
      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(response_data['user']).to be_kind_of(Hash)
      expect(response_data['user']['id']).to eq(user.id)
    end
  end
end
