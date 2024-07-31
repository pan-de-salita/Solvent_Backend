# frozen_string_literal: true

require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Solutions Requests', type: :request do
  let!(:puzzle_creator) { create(:user) }
  let!(:puzzle_solver) { create(:user) }
  let!(:language) { create(:language, name: 'Ruby', id: 72) }
  let!(:puzzle) { create(:puzzle, creator: puzzle_solver, expected_output: 'hello world') }
  let!(:solution) { create(:solution, user: puzzle_solver, puzzle:, language:) }
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }
  let(:auth_headers) { Devise::JWT::TestHelpers.auth_headers(headers, puzzle_solver) }
  let(:puzzle_creator_auth_headers) { Devise::JWT::TestHelpers.auth_headers(headers, puzzle_creator) }
  let(:mock_judge0_client) { double('Judge0 Client') }

  before do
    allow(Judge0::Client).to receive(:new).and_return(mock_judge0_client)
    allow(mock_judge0_client).to receive(:evaluate_source_code).with(
      source_code: 'puts "hello world"',
      language_id: language.id
    ).and_return(
      status: 200,
      data: {
        stdout: 'hello world\n'
      }
    )
  end

  context 'authorized user' do
    describe 'GET /api/v1/puzzles/:puzzle_id/solutions' do
      it 'returns all solutions to the specified puzzle' do
        get "/api/v1/puzzles/#{puzzle.id}/solutions", headers: auth_headers
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['data']['all_solutions'].map { |s| s['user_id'] }).to include(puzzle_solver.id)
      end
    end

    describe 'GET /api/v1/puzzles/:puzzle_id/solutions/:id' do
      it 'returns the specified solution to the specified puzzle' do
        get "/api/v1/puzzles/#{puzzle.id}/solutions/#{solution.id}", headers: auth_headers
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['data']['solution']['id']).to eq(solution.id)
      end
    end

    describe 'POST /api/v1/puzzles/:puzzle_id/solutions' do
      it 'creates a new solution' do
        expect do
          post "/api/v1/puzzles/#{puzzle.id}/solutions",
               headers: auth_headers,
               params: {
                 solution: {
                   source_code: 'puts "hello world"',
                   language_id: language.id
                 }
               }.to_json
        end.to change(Solution, :count).by(1)
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['data']['new_solution']['id']).to eq(Solution.recent.first.id)
      end
    end

    describe 'PATCH /api/v1/puzzles/:puzzle_id/solutions/:id' do
      it 'updates the specified solution' do
        solution_to_update = create(:solution, user: puzzle_solver, puzzle:, language:,
                                               source_code: 'puts "hello"')
        patch "/api/v1/puzzles/#{puzzle.id}/solutions/#{solution_to_update.id}",
              headers: auth_headers,
              params: {
                solution: {
                  source_code: 'puts "hello world"'
                }
              }.to_json
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['data']['updated_solution']['source_code']).to eq('puts "hello world"')
      end
    end

    describe 'DELETE /api/v1/puzzles/:puzzle_id/solutions/:id' do
      it 'deletes the specified solution' do
        solution_to_delete = create(:solution, user: puzzle_solver, puzzle:, language:)
        expect { delete "/api/v1/puzzles/#{puzzle.id}/solutions/#{solution_to_delete.id}", headers: auth_headers }
          .to change(Solution, :count).by(-1)
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['data']['deleted_solution']['id']).to eq(solution_to_delete.id)
      end
    end
  end

  context 'unauthorized user' do
    describe 'GET /api/v1/puzzles/:puzzle_id/solutions' do
      it 'returns an unauthorized status' do
        get("/api/v1/puzzles/#{puzzle.id}/solutions", headers:)
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['data']).to be_nil
      end
    end

    describe 'GET /api/v1/puzzles/:puzzle_id/solutions/:id' do
      it 'returns an unauthorized status' do
        get("/api/v1/puzzles/#{puzzle.id}/solutions/#{solution.id}", headers:)
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['data']).to be_nil
      end
    end

    describe 'POST /api/v1/puzzles/:puzzle_id/solutions' do
      it 'returns an unauthorized status' do
        expect do
          post "/api/v1/puzzles/#{puzzle.id}/solutions",
               headers:,
               params: {
                 solution: {
                   source_code: 'puts "hello world"',
                   language_id: language.id
                 }
               }.to_json
        end.to change(Solution, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['data']).to be_nil
      end
    end

    describe 'PATCH /api/v1/puzzles/:puzzle_id/solutions/:id' do
      let(:solution_to_update) do
        create(:solution, user: puzzle_solver, puzzle:, language:, source_code: 'puts "hello"')
      end

      it 'returns an unauthorized status (when there is no logged-in user)' do
        patch "/api/v1/puzzles/#{puzzle.id}/solutions/#{solution_to_update.id}",
              headers:,
              params: {
                solution: {
                  source_code: 'puts "hello world"'
                }
              }.to_json
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['data']).to be_nil
        expect(solution_to_update.source_code).to eq('puts "hello"')
      end

      it 'returns an unauthorized status (when logged-in user is not solutions creator)' do
        patch "/api/v1/puzzles/#{puzzle.id}/solutions/#{solution_to_update.id}",
              headers: puzzle_creator_auth_headers,
              params: {
                solution: {
                  source_code: 'puts "hello world"'
                }
              }.to_json
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['data']).to be_nil
        expect(solution_to_update.source_code).to eq('puts "hello"')
      end
    end

    describe 'DELETE /api/v1/puzzles/:puzzle_id/solutions/:id' do
      it 'returns an unauthorized status' do
        solution_to_delete = create(:solution, user: puzzle_solver, puzzle:, language:)
        expect do
          delete "/api/v1/puzzles/#{puzzle.id}/solutions/#{solution_to_delete.id}",
                 headers: puzzle_creator_auth_headers
        end
          .to change(Solution, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['data']).to be_nil
      end
    end
  end
end
