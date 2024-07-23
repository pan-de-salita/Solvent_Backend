# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Puzzle, type: :model do
  let!(:puzzle) { build :puzzle, :with_title, :with_description, :with_start_date, :with_end_date }

  context 'when attributes are valid' do
    it 'creates a Puzzle instance' do
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

    it 'rejects an creation attempt when start_date is less than Date.today' do
      puzzle.start_date = Date.yesterday
      puzzle_with_invalid_start_date = puzzle
      expect(puzzle_with_invalid_start_date.start_date).to be < Date.today
      expect(puzzle_with_invalid_start_date).to_not be_valid
    end

    it 'rejects an instance creation attempt when end_date is less than or equal_to Date.today' do
      puzzle.end_date = Date.yesterday
      puzzle_with_invalid_end_date = puzzle
      expect(puzzle_with_invalid_end_date.end_date).to be < puzzle_with_invalid_end_date.start_date
      expect(puzzle_with_invalid_end_date).to_not be_valid

      puzzle.end_date = Date.today
      puzzle_with_invalid_end_date = puzzle
      expect(puzzle_with_invalid_end_date.end_date).to be == Date.today
      expect(puzzle_with_invalid_end_date).to_not be_valid
    end
  end

  context 'when updating start/end_date attributes' do
    let!(:saved_puzzle) { create :puzzle, :with_title, :with_description, :with_start_date, :with_end_date }

    it 'rejects a instance update attempt when start_date is less than Date.today' do
      expect(saved_puzzle.update(start_date: Date.yesterday)).to be_falsy
    end

    it 'rejects a puzzle instance creation attempt when end_date is less than or equal_to Date.today' do
      expect(saved_puzzle.update(end_date: Date.yesterday)).to be_falsy
      expect(saved_puzzle.update(end_date: Date.today)).to be_falsy
    end
  end
end
