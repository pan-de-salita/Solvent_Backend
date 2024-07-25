# frozen_string_literal: true

# == Schema Information
#
# Table name: puzzles
#
#  id          :bigint           not null, primary key
#  title       :string           not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :bigint           not null
#  creator_id  :bigint           not null
#  tags        :string           default([]), is an Array
#
require 'rails_helper'

RSpec.describe Puzzle, type: :model do
  let!(:puzzle) { build :puzzle, :with_title, :with_description }

  context 'when attributes are valid' do
    it 'creates a Puzzle instance' do
      p puzzle
      valid_puzzle = puzzle
      expect(valid_puzzle).to be_valid
    end
  end

  context 'when attributes are invalid/missing' do
    it 'rejects an instance creation attempt when title is not unique' do
      puzzle_with_duplicate_title = puzzle.dup
      puzzle.save
      expect(puzzle_with_duplicate_title.title).to eq(puzzle.title)
      expect(puzzle_with_duplicate_title).to_not be_valid
    end
  end
end
