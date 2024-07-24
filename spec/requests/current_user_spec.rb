require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'CurrentUsers', type: :request do
  before do
    # TODO: change when User model is updated.
    @user = User.create(
      email: 'test@mail.com',
      password: 'foobar',
      password_confirmation: 'foobar',
      jti: SecureRandom.uuid
    )
  end

  describe 'GET /index' do
    it 'returns http success' do
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, @user)
      get '/api/v1/auth/current_user', headers: auth_headers
      expect(response).to have_http_status(:success)
    end
  end
end
