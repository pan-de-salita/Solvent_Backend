require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Like Requests', type: :request do
  let!(:puzzle_creator) { create(:user) }
  let!(:puzzle_solver) { create(:user) }
  let!(:liker) { create(:user) }
  let!(:language) { create(:language, name: 'Ruby', id: 72) }
  let!(:puzzle) { create(:puzzle, creator: puzzle_solver, expected_output: 'hello world') }
  let!(:solution) { create(:solution, user: puzzle_solver, puzzle:, language:) }
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }
  let(:auth_headers) { Devise::JWT::TestHelpers.auth_headers(headers, liker) }
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

  describe 'POST /api/v1/puzzles/:puzzle_id/solutions/:solution_id/likes' do
    it 'allows the logged_in user to like the specified solution' do
      expect do
        post("/api/v1/puzzles/#{puzzle.id}/solutions/#{solution.id}/likes", headers: auth_headers)
      end.to change(Like, :count).by(1)
      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(response_data['new_like']).to be_kind_of(Hash)
      expect(response_data['new_like']['id']).to eq(Like.last.id)
      expect(solution.likers).to include(liker)
      expect(liker.liked_solutions).to include(solution)
    end
  end

  describe 'DELETE /api/v1/puzzles/:puzzle_id/solutions/:solution_id/likes/:id' do
    let!(:like) { create :like, user_id: liker.id, solution_id: solution.id }

    it 'allows the logged_in user to unlike a solution' do
      expect do
        delete("/api/v1/puzzles/#{puzzle.id}/solutions/#{solution.id}/likes/#{like.id}", headers: auth_headers)
      end.to change(Like, :count).by(-1)
      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(response_data['deleted_like']).to be_kind_of(Hash)
      expect(response_data['deleted_like']['id']).to eq(like.id)
      expect(solution.likers).to_not include(liker)
      expect(liker.liked_solutions).to_not include(solution)
    end
  end

  context 'unauthorized user' do
    let(:other_user_auth_headers) { Devise::JWT::TestHelpers.auth_headers(headers, puzzle_creator) }

    describe 'DELETE /api/v1/puzzles/:puzzle_id/solutions/:solution_id/likes/:id' do
      let!(:like) { create :like, user_id: liker.id, solution_id: solution.id }

      it 'allows the logged_in user to unlike a solution' do
        expect do
          delete("/api/v1/puzzles/#{puzzle.id}/solutions/#{solution.id}/likes/#{like.id}",
                 headers: other_user_auth_headers)
        end.to change(Like, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
