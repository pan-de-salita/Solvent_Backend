# == Schema Information
#
# Table name: solutions
#
#  id          :bigint           not null, primary key
#  source_code :text             default(""), not null
#  iteration   :integer          not null
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
    create :puzzle, title: 'Multiples of 3 or 5', description: 'Find the sum of all the multiples of 3 or 5 below 1000.',
                    creator_id: user.id
  end
  let!(:ruby) { create :language, name: 'Ruby' }
  let!(:solution) { build :solution, language_id: ruby.id, puzzle_id: puzzle.id, user_id: user.id }

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
      end
    end
  end

  context 'when a new solution to the same puzzle has the same iteration' do
    it 'rejects an instance creation attempt' do
      new_solution = solution.dup
      solution.save
      expect(new_solution.iteration).to eq(solution.iteration)
      expect(new_solution).to_not be_valid
    end
  end

  context 'when a new solution to the same puzzle has a nonsequential iteration' do
    it 'rejects an instance creation attempt' do
      new_solution = solution.dup
      solution.save
      new_solution.iteration += 2
      expect(new_solution.iteration).to eq(3)
      expect(new_solution).to_not be_valid
    end
  end
end
