require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { create :user }

  describe 'GET api/v1/users/:id' do
    it 'returns the specified user' do
      get :show, params: { id: user.id }

      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(response_data['user']).to be_kind_of(Hash)
      expect(response_data['user']['id']).to eq(user.id)
    end
  end
end
