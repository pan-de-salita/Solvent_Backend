require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Solutions Requests', type: :request do
  let!(:puzzle_creator) { create :user }
  let!(:puzzle_solver) { create :user }
  let!(:language) { create :language, name: 'Ruby', id: 72 }
  let!(:puzzle) { create :puzzle, creator_id: puzzle_solver.id, expected_output: 'hello world' }
  let!(:solution) { create :solution, user_id: puzzle_solver.id, puzzle_id: puzzle.id, language_id: language.id }
  let!(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }
  let!(:auth_headers) do
    Devise::JWT::TestHelpers.auth_headers(headers, puzzle_solver)
  end
  let(:mock_judge0_client) { double('Judge0 Client') }
  before do
    allow(Judge0::Client).to receive(:new).and_return(mock_judge0_client)
    allow(mock_judge0_client).to receive(:evaluate_source_code).with(
      source_code: 'p "hello world"',
      language_id: language.id
    ).and_return({
                   status: 200,
                   data: {
                     stdout: 'hello world\n'
                   }
                 })
  end

  describe 'GET /api/v1/puzzles/:puzzle_id/solutions' do
    it 'returns all solutions to the specified puzzle' do
      expect(Solution.all.count).to eq(1)
      get("/api/v1/puzzles/#{puzzle.id}/solutions", headers: auth_headers)
      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(response_data['all_solutions']).to be_kind_of(Array)
      expect(response_data['all_solutions'].map do |solution|
               solution['user_id']
             end.include?(puzzle_solver.id)).to be_truthy
    end
  end

  describe 'GET /api/v1/puzzles/:puzzle_id/solutions/:id' do
    it 'returns the specified solution to the specified puzzle' do
      expect(Solution.all.count).to eq(1)
      get("/api/v1/puzzles/#{puzzle.id}/solutions/#{solution.id}", headers: auth_headers)
      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(response_data['solution']).to be_kind_of(Hash)
      expect(response_data['solution']['id']).to eq(solution.id)
    end
  end

  describe 'POST /api/v1/puzzles/:puzzle_id' do
    it 'creates a new solution' do
      expect(Solution.all.count).to eq(1)
      post "/api/v1/puzzles/#{puzzle.id}/solutions",
           headers: auth_headers,
           params: {
             solution: {
               source_code: 'p "hello world"',
               language_id: 72
             }
           }.to_json
      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(Solution.all.count).to eq(2)
      expect(response_data['new_solution']['id']).to eq(Solution.recent.first.id)
    end
  end

  # describe 'PATCH /api/v1/puzzles/:id' do
  #   it 'updates a new puzzle with expected_output containing a new-line character at its end' do
  #     puzzle_to_update = create :puzzle, creator_id: user.id, expected_output: 'Update me.'
  #     expect(Puzzle.all.count).to eq(4)
  #     expect(puzzle_to_update.expected_output).to eq('Update me.')
  #     patch "/api/v1/puzzles/#{puzzle_to_update.id}",
  #           headers: auth_headers,
  #           params: {
  #             puzzle: {
  #               expected_output: "I've been updated."
  #             }
  #           }.to_json
  #     response_data = JSON.parse(response.body)['data']
  #     expect(response).to have_http_status(:success)
  #     expect(response_data['updated_puzzle']['id']).to eq(puzzle_to_update.id)
  #     expect(response_data['updated_puzzle']['expected_output']).to eq("I've been updated.")
  #   end
  # end
  #
  # describe 'DELETE /api/v1/puzzles/:id' do
  #   it 'deletes the specified puzzle' do
  #     puzzle_to_delete = create :puzzle, creator_id: user.id
  #     expect(Puzzle.all.count).to eq(4)
  #     delete "/api/v1/puzzles/#{puzzle_to_delete.id}", headers: auth_headers
  #     response_data = JSON.parse(response.body)['data']
  #     expect(response).to have_http_status(:success)
  #     expect(Puzzle.all.count).to eq(3)
  #     expect(response_data['deleted_puzzle']['id']).to eq(puzzle_to_delete.id)
  #   end
  # end
end
