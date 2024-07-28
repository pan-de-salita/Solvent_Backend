# == Schema Information
#
# Table name: solutions
#
#  id          :bigint           not null, primary key
#  source_code :text             default(""), not null
#  language_id :bigint           not null
#  puzzle_id   :bigint           not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Solution, type: :model do
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
  let!(:solution) { build :solution, language_id: ruby.id, puzzle_id: puzzle.id, user_id: user.id }

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

  context 'when attributes are valid' do
    it 'creates a Solution instance' do
      expect(solution).to be_valid
    end
  end

  context 'when language_id, puzzle_id, or user_id is blank' do
    it 'rejects an instance creation attempt' do
      %w[language_id puzzle_id user_id].each do |attribute|
        solution.send("#{attribute}=", nil)
        expect(solution.send(attribute)).to be_falsy
        expect(solution).to_not be_valid
      rescue ArgumentError => e
        expect(e).to be_truthy
      end
    end
  end
end
