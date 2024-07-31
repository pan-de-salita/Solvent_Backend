# frozen_string_literal: true

# == Schema Information
#
# Table name: puzzles
#
#  id              :bigint           not null, primary key
#  title           :string           not null
#  description     :text             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  creator_id      :bigint           not null
#  tags            :string           default([]), is an Array
#  expected_output :text             not null
#
require 'rails_helper'

RSpec.describe Puzzle, type: :model do
  let!(:user) { create :user }
  let!(:language) { create :language }
  let(:puzzle) { build :puzzle, creator_id: user.id }

  context 'when attributes are valid' do
    it 'creates a Puzzle instance' do
      expect(puzzle).to be_valid
    end
  end

  context 'when title is not unique' do
    it 'rejects an instance creation attempt' do
      puzzle_with_duplicate_title = puzzle.dup
      puzzle.save
      expect(puzzle_with_duplicate_title.title).to eq(puzzle.title)
      expect(puzzle_with_duplicate_title).to_not be_valid
    end
  end

  context 'when creator_id is nil' do
    it 'rejects an instance creation attempt' do
      puzzle.creator_id = nil
      expect(puzzle.creator_id).to be_falsy
      expect(puzzle).to_not be_valid
    end
  end
end
