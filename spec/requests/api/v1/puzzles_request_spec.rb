# frozen_string_literal: true

require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Puzzles Requests', type: :request do
  let!(:user) { create(:user) }
  let!(:language) { create(:language, name: 'Ruby', id: 72) }
  let!(:puzzles) { create_list(:puzzle, 3, creator: user) }
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }

  context "actions that don't require authorization" do
    describe 'GET /api/v1/puzzles' do
      it 'returns all puzzles' do
        get('/api/v1/puzzles', headers:)
        response_data = JSON.parse(response.body)['data']

        expect(response).to have_http_status(:success)
        expect(response_data['all_puzzles']).to be_an(Array)
        expect(response_data['all_puzzles'].first['id']).to eq(Puzzle.recent.first.id)
      end
    end

    describe 'GET /api/v1/puzzles/:id' do
      it 'returns the specified puzzle without its solutions' do
        get("/api/v1/puzzles/#{puzzles.first.id}", headers:)
        response_data = JSON.parse(response.body)['data']

        expect(response).to have_http_status(:success)
        expect(response_data['puzzle']).to be_a(Hash)
        expect(response_data['puzzle']['id']).to eq(puzzles.first.id)
        expect(response_data['puzzle']['solutions_by_languages']).to be_nil
      end
    end
  end

  context 'actions that require authorization' do
    let(:auth_headers) { Devise::JWT::TestHelpers.auth_headers(headers, user) }

    describe 'GET /api/v1/puzzles/:id' do
      it 'returns the specified puzzle with its solutions' do
        get "/api/v1/puzzles/#{puzzles.first.id}", headers: auth_headers
        response_data = JSON.parse(response.body)['data']

        expect(response).to have_http_status(:success)
        expect(response_data['puzzle']).to be_a(Hash)
        expect(response_data['puzzle']['id']).to eq(puzzles.first.id)
        expect(response_data['puzzle']['solutions_by_languages']).to be_a(Hash)
      end
    end

    describe 'GET /api/v1/puzzles/random' do
      it 'returns a random puzzle' do
        get '/api/v1/puzzles/random', headers: auth_headers
        response_data = JSON.parse(response.body)['data']

        expect(response).to have_http_status(:success)
        expect(response_data['puzzle']).to be_a(Hash)
        expect(Puzzle.all.map(&:id)).to include(response_data['puzzle']['id'])
        expect(response_data['puzzle']['solutions_by_languages']).to be_a(Hash)
      end
    end

    describe 'POST /api/v1/puzzles' do
      it 'creates a new puzzle' do
        expect do
          post '/api/v1/puzzles',
               headers: auth_headers,
               params: {
                 puzzle: {
                   title: 'Test Puzzle For Request',
                   description: 'This is Test Puzzle',
                   expected_output: "hello world.\n" # Ensure it ends with a newline
                 }
               }.to_json
        end.to change(Puzzle, :count).by(1)

        response_data = JSON.parse(response.body)['data']
        expect(response).to have_http_status(:success)
        expect(response_data['new_puzzle']['id']).to eq(Puzzle.recent.first.id)
      end
    end

    describe 'PATCH /api/v1/puzzles/:id' do
      it 'updates the specified puzzle with new expected_output' do
        puzzle_to_update = create(:puzzle, creator: user, expected_output: 'Update me.')

        patch "/api/v1/puzzles/#{puzzle_to_update.id}",
              headers: auth_headers,
              params: {
                puzzle: {
                  expected_output: "I've been updated."
                }
              }.to_json

        response_data = JSON.parse(response.body)['data']
        expect(response).to have_http_status(:success)
        expect(response_data['updated_puzzle']['id']).to eq(puzzle_to_update.id)
        expect(response_data['updated_puzzle']['expected_output']).to eq("I've been updated.")
      end
    end

    describe 'DELETE /api/v1/puzzles/:id' do
      it 'deletes the specified puzzle' do
        puzzle_to_delete = create(:puzzle, creator: user)

        expect do
          delete "/api/v1/puzzles/#{puzzle_to_delete.id}", headers: auth_headers
        end.to change(Puzzle, :count).by(-1)

        response_data = JSON.parse(response.body)['data']
        expect(response).to have_http_status(:success)
        expect(response_data['deleted_puzzle']['id']).to eq(puzzle_to_delete.id)
      end
    end
  end

  context 'a non-logged-in user attempts non-GET requests' do
    describe 'POST /api/v1/puzzles' do
      it 'rejects the creation of a new puzzle' do
        expect do
          post '/api/v1/puzzles',
               headers:,
               params: {
                 puzzle: {
                   title: 'Test Puzzle For Request',
                   description: 'This is Test Puzzle',
                   expected_output: 'hello world.'
                 }
               }.to_json
        end.not_to change(Puzzle, :count)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['data']).to be_nil
      end
    end

    describe 'PATCH /api/v1/puzzles/:id' do
      it 'rejects the update of the specified puzzle' do
        puzzle_to_update = create(:puzzle, creator: user, expected_output: 'Update me.')

        patch "/api/v1/puzzles/#{puzzle_to_update.id}",
              headers:,
              params: {
                puzzle: {
                  expected_output: "I've been updated."
                }
              }.to_json

        expect(response).to have_http_status(:unauthorized)
        expect(puzzle_to_update.reload.expected_output).to eq('Update me.')
        expect(JSON.parse(response.body)['data']).to be_nil
      end
    end

    describe 'DELETE /api/v1/puzzles/:id' do
      it 'rejects the deletion of the specified puzzle' do
        puzzle_to_delete = create(:puzzle, creator: user)

        expect do
          delete "/api/v1/puzzles/#{puzzle_to_delete.id}", headers:
        end.not_to change(Puzzle, :count)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['data']).to be_nil
      end
    end
  end
end
