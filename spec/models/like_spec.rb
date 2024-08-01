# == Schema Information
#
# Table name: solution_likes
#
#  id          :bigint           not null, primary key
#  user_id     :bigint           not null
#  solution_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Like, type: :model do
  let!(:user) { create :user }
  let!(:puzzle) do
    create(
      :puzzle,
      title: 'Multiples of 3 or 5',
      description: 'Find the sum of all the multiples of 3 or 5 below 1000.',
      creator_id: user.id,
      expected_output: '233168'
    )
  end
  let!(:ruby) { create :language, id: 72, name: 'Ruby' }
  let!(:solution) { create :solution, language_id: ruby.id, puzzle_id: puzzle.id, user_id: user.id }
  let(:mock_judge0_client) { double('Judge0 Client') }
  before do
    allow(Judge0::Client).to receive(:new).and_return(mock_judge0_client)
    allow(mock_judge0_client).to receive(:evaluate_source_code).with(
      source_code: solution.source_code,
      language_id: ruby.id
    ).and_return({
                   status: 200,
                   data: {
                     stdout: '233168\n'
                   }
                 })
  end
  let!(:like) { build :like, user_id: user.id, solution_id: solution.id }

  context 'when attributes are valid' do
    it 'creates a Like instance' do
      expect(like).to be_valid
      expect do
        like.save
      end.to change(Like, :count).by(1)
      expect(user.liked_solutions).to include(solution)
      expect(solution.likers).to include(user)
    end
  end
end
