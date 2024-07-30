require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'CurrentUsers', type: :request do
  let!(:user) { create(:user) }

  describe 'GET /index' do
    it 'returns http success' do
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
      get '/api/v1/current_user', headers: auth_headers

      expect(response).to have_http_status(:success)
    end
  end
end
