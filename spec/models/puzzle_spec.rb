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
  let!(:user) { create :user }
  let!(:language) { create :language }
  let(:puzzle) { build :puzzle, language_id: language.id, creator_id: user.id }

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

  context 'when creator_id and language_id is nil' do
    it 'rejects an instance creation attempt' do
      puzzle.language_id = nil
      puzzle.creator_id = nil
      expect(puzzle.language_id).to be_falsy
      expect(puzzle.creator_id).to be_falsy
      expect(puzzle).to_not be_valid
    end
  end

  context 'when starter_code is nil' do
    it 'rejects an instance creation attempt' do
      puzzle.starter_code = nil
      expect(puzzle.starter_code).to be_falsy
      expect(puzzle).to_not be_valid
    end
  end
end
