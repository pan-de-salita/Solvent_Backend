require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Puzzle Requests', type: :request do
  let!(:user) { create :user }
  let!(:language) { create :language, name: 'Ruby', id: 72 }
  let!(:puzzle_one) { create :puzzle, creator_id: user.id }
  let!(:puzzle_two) { create :puzzle, creator_id: user.id }
  let!(:puzzle_three) { create :puzzle, creator_id: user.id }
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }

  context "actions that don't require authorization" do
    describe 'GET /api/v1/puzzles' do
      it 'returns all puzzles' do
        get('/api/v1/puzzles', headers:)
        response_data = JSON.parse(response.body)['data']
        expect(response).to have_http_status(:success)
        expect(response_data['all_puzzles']).to be_kind_of(Array)
        expect(response_data['all_puzzles'].first['id']).to eq(Puzzle.recent.first.id)
      end
    end

    describe 'GET /api/v1/puzzles/:id' do
      it 'returns the specified puzzle without its solutions' do
        get("/api/v1/puzzles/#{puzzle_one.id}", headers:)
        response_data = JSON.parse(response.body)['data']
        expect(response).to have_http_status(:success)
        expect(response_data['puzzle']).to be_kind_of(Hash)
        expect(response_data['puzzle']['id']).to eq(puzzle_one.id)
        expect(response_data['puzzle']['solutions']).to be_nil
      end
    end
  end

  context 'actions that require authorization' do
    let!(:auth_headers) do
      Devise::JWT::TestHelpers.auth_headers(headers, user)
    end

    describe 'GET /api/v1/puzzles/:id' do
      it 'returns the specified puzzle with its solutions' do
        get("/api/v1/puzzles/#{puzzle_one.id}", headers: auth_headers)
        response_data = JSON.parse(response.body)['data']
        expect(response).to have_http_status(:success)
        expect(response_data['puzzle']).to be_kind_of(Hash)
        expect(response_data['puzzle']['id']).to eq(puzzle_one.id)
        expect(response_data['puzzle']['solutions']).to be_kind_of(Array)
      end
    end

    describe 'POST /api/v1/puzzles' do
      it 'creates a new puzzle with expected_output containing a new-line character at its end' do
        expect(Puzzle.all.count).to eq(3)
        post '/api/v1/puzzles',
             headers: auth_headers,
             params: {
               puzzle: {
                 title: 'Test Puzzle For Request',
                 description: 'This is Test Puzzle',
                 expected_output: 'hello world.'
               }
             }.to_json
        response_data = JSON.parse(response.body)['data']
        expect(response).to have_http_status(:success)
        expect(Puzzle.all.count).to eq(4)
        expect(response_data['new_puzzle']['id']).to eq(Puzzle.recent.first.id)
        expect(response_data['new_puzzle']['expected_output']).to end_with("\n")
      end
    end

    describe 'PATCH /api/v1/puzzles/:id' do
      it 'updates a new puzzle with expected_output containing a new-line character at its end' do
        puzzle_to_update = create :puzzle, creator_id: user.id, expected_output: 'Update me.'
        expect(Puzzle.all.count).to eq(4)
        expect(puzzle_to_update.expected_output).to eq("Update me.\n")
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
        expect(response_data['updated_puzzle']['expected_output']).to eq("I've been updated.\n")
        expect(response_data['updated_puzzle']['expected_output']).to end_with("\n")
      end
    end

    describe 'DELETE /api/v1/puzzles/:id' do
      it 'deletes the specified puzzle' do
        puzzle_to_delete = create :puzzle, creator_id: user.id
        expect(Puzzle.all.count).to eq(4)
        delete "/api/v1/puzzles/#{puzzle_to_delete.id}", headers: auth_headers
        response_data = JSON.parse(response.body)['data']
        expect(response).to have_http_status(:success)
        expect(Puzzle.all.count).to eq(3)
        expect(response_data['deleted_puzzle']['id']).to eq(puzzle_to_delete.id)
      end
    end
  end

  context 'a non-loggedin user attempts non-GET requests' do
    describe 'POST /api/v1/puzzles' do
      it 'rejects the creation of a new puzzle' do
        expect(Puzzle.all.count).to eq(3)
        post '/api/v1/puzzles',
             headers:,
             params: {
               puzzle: {
                 title: 'Test Puzzle For Request',
                 description: 'This is Test Puzzle',
                 expected_output: 'hello world.'
               }
             }.to_json
        expect(response).to have_http_status(:unauthorized)
        expect(Puzzle.all.count).to eq(3)
        response_data = JSON.parse(response.body)
        expect(response_data['data']).to be_nil
      end
    end

    describe 'PATCH /api/v1/puzzles/:id' do
      it 'rejects the update of the specified puzzle' do
        puzzle_to_update = create :puzzle, creator_id: user.id, expected_output: 'Update me.'
        expect(Puzzle.all.count).to eq(4)
        expect(puzzle_to_update.expected_output).to eq("Update me.\n")
        patch "/api/v1/puzzles/#{puzzle_to_update.id}",
              headers:,
              params: {
                puzzle: {
                  expected_output: "I've been updated."
                }
              }.to_json
        expect(response).to have_http_status(:unauthorized)
        expect(puzzle_to_update.expected_output).to eq("Update me.\n")
        response_data = JSON.parse(response.body)
        expect(response_data['data']).to be_nil
      end
    end

    describe 'DELETE /api/v1/puzzles/:id' do
      it 'rejects the deletion of the specified puzzle' do
        puzzle_to_delete = create :puzzle, creator_id: user.id
        expect(Puzzle.all.count).to eq(4)
        delete("/api/v1/puzzles/#{puzzle_to_delete.id}", headers:)
        expect(response).to have_http_status(:unauthorized)
        expect(Puzzle.all.count).to eq(4)
        response_data = JSON.parse(response.body)
        expect(response_data['data']).to be_nil
      end
    end
  end
end
