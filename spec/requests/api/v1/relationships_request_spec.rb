require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Relationships Requests', type: :request do
  let!(:user_one) { create :user }
  let!(:user_two) { create :user }
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }
  let!(:auth_headers) do
    Devise::JWT::TestHelpers.auth_headers(headers, user_one)
  end

  describe 'POST /api/v1/relationships' do
    it 'allows the logged_in user to follow a specified user' do
      expect(user_one.following.count).to eq(0)
      expect(user_two.followers.count).to eq(0)
      post('/api/v1/relationships',
           headers: auth_headers,
           params: {
             followed_id: user_two.id
           }.to_json)
      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(user_one.following.count).to eq(1)
      expect(user_two.followers.count).to eq(1)
      expect(response_data['new_relationship']).to be_kind_of(Hash)
      expect(response_data['new_relationship']['follower']['id']).to eq(user_one.id)
      expect(response_data['new_relationship']['followed']['id']).to eq(user_two.id)
    end
  end

  describe 'DELETE /api/v1/relationships/:id' do
    it 'allows the logged_in user to unfollow a specified user' do
      post('/api/v1/relationships',
           headers: auth_headers,
           params: {
             followed_id: user_two.id
           }.to_json)
      expect(user_one.following.count).to eq(1)
      expect(user_two.followers.count).to eq(1)
      delete("/api/v1/relationships/#{Relationship.first.id}",
             headers: auth_headers)
      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(user_one.following.count).to eq(0)
      expect(user_two.followers.count).to eq(0)
      expect(response_data['deleted_relationship']).to be_kind_of(Hash)
      expect(response_data['deleted_relationship']['follower']['id']).to eq(user_one.id)
      expect(response_data['deleted_relationship']['followed']['id']).to eq(user_two.id)
    end
  end
end
