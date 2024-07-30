require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'CurrentUsers', type: :request do
  let!(:user_one) { create :user }
  let!(:user_two) { create :user }
  let!(:language) { create :language, name: 'Ruby', id: 72 }
  let(:puzzle) { create(:puzzle, creator_id: user_one.id, expected_output: 'expected_output') }
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }

  describe 'GET api/v1/current_user' do
    it 'returns the current_user' do
      auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user_one)
      get '/api/v1/current_user', headers: auth_headers
      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(response_data['current_user']).to be_kind_of(Hash)
      expect(response_data['current_user']['id']).to eq(user_one.id)
    end
  end

  describe 'GET api/v1/current_user/followers' do
    it "returns all of current_user's followers" do
      expect { user_two.follow(user_one) }
        .to change { user_one.followers.count }
        .from(0)
        .to(1)

      auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user_one)
      get '/api/v1/current_user/followers', headers: auth_headers
      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(response_data['current_user_followers'].first['id']).to eq(user_one.followers.first.id)
    end
  end

  describe 'GET api/v1/current_user/following' do
    it "returns current_user's following" do
      expect { user_two.follow(user_one) }
        .to change { user_two.following.count }
        .from(0)
        .to(1)
      auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user_two)
      get '/api/v1/current_user/following', headers: auth_headers
      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(response_data['current_user_following'].first['id']).to eq(user_two.following.first.id)
    end
  end

  describe 'GET api/v1/current_user/created_puzzles' do
    it "returns current_user's created puzzles" do
      expect { puzzle }
        .to change { user_one.puzzles.count }
        .from(0)
        .to(1)

      auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user_one)
      get '/api/v1/current_user/created_puzzles', headers: auth_headers
      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(response_data['current_user_created_puzzles'].first['id']).to eq(user_one.puzzles.first.id)
    end
  end

  context 'having solved a puzzle' do
    let(:mock_judge0_client) { double('Judge0 Client') }
    before do
      allow(Judge0::Client).to receive(:new).and_return(mock_judge0_client)
      allow(mock_judge0_client).to receive(:evaluate_source_code).with(
        source_code: 'p expected_output',
        language_id: language.id
      ).and_return({
                     status: 200,
                     data: {
                       stdout: 'expected_output\n'
                     }
                   })
    end

    before do
      @puzzle_solver = create :user
      @puzzle_solver.solutions.create(source_code: 'p expected_output', language_id: language.id, puzzle_id: puzzle.id,
                                      user_id: user_one.id)
    end

    describe 'GET api/v1/current_user/completed_solutions' do
      it "returns current_user's completed_solutions" do
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, @puzzle_solver)
        get '/api/v1/current_user/completed_solutions', headers: auth_headers
        response_data = JSON.parse(response.body)['data']
        expect(response).to have_http_status(:success)
        expect(response_data['current_user_completed_solutions'].first['id']).to eq(@puzzle_solver.solutions.first.id)
      end
    end

    describe 'GET api/v1/current_user/solved_puzzles' do
      it "returns current_user's solved_puzzles" do
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, @puzzle_solver)
        get '/api/v1/current_user/solved_puzzles', headers: auth_headers
        response_data = JSON.parse(response.body)['data']
        expect(response).to have_http_status(:success)
        expect(response_data['current_user_solved_puzzles'].first['id']).to eq(@puzzle_solver.solutions.map(&:puzzle).uniq.first.id)
      end
    end
  end
end
