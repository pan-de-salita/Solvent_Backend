# frozen_string_literal: true

require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Authorization Requests', type: :request do
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }

  context 'registrations' do
    describe 'POST /api/v1/signup' do
      it 'creates a new user' do
        expect do
          post('/api/v1/signup',
               headers:,
               params: {
                 user: {
                   username: 'new_user',
                   email: 'testuser@mail.com',
                   password: 'foobar',
                   password_confirmation: 'foobar'
                 }
               }.to_json)
        end.to change(User, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end
  end

  context 'sessions' do
    before do
      post('/api/v1/signup',
           headers:,
           params: {
             user: {
               username: 'user_for_sessions',
               email: 'user_for_sessions@mail.com',
               password: 'foobar',
               password_confirmation: 'foobar'
             }
           }.to_json)
      @user_for_sessions = User.find_by(username: 'user_for_sessions')
    end

    describe 'POST /api/v1/login' do
      it 'logs in a user' do
        post('/api/v1/login',
             headers:,
             params: {
               user: {
                 email: @user_for_sessions.email,
                 password: 'foobar'
               }
             }.to_json)
        expect(response).to have_http_status(:success)
        expect(response.headers['authorization']).to be_present
      end
    end

    describe 'DELETE /api/v1/logout' do
      it 'logs out a user if JWT tokent present' do
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, @user_for_sessions)
        delete('/api/v1/logout', headers: auth_headers)
        expect(response).to have_http_status(:success)
      end

      it 'rejects logout attempt if JWT tokent missing' do
        delete('/api/v1/logout', headers:)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
