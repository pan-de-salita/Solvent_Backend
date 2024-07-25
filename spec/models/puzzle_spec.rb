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
  let(:puzzle) { build :puzzle, title: 'Not the same as @puzzle' }

  before do
    @puzzle = build :puzzle
    @puzzle.update(language_id: language.id, creator_id: user.id)
  end

  context 'when attributes are valid' do
    it 'creates a Puzzle instance' do
      expect(@puzzle).to be_valid
    end
  end

  context 'when title is not unique' do
    it 'rejects an instance creation attempt' do
      puzzle_with_duplicate_title = @puzzle.dup
      @puzzle.save
      expect(puzzle_with_duplicate_title.title).to eq(@puzzle.title)
      expect(puzzle_with_duplicate_title).to_not be_valid
    end
  end

  context 'when creator_id and language_id is null' do
    it 'rejects an instance creation attempt' do
      puzzle_without_creator_id_and_langauge_id = puzzle
      expect(puzzle_without_creator_id_and_langauge_id.creator_id).to be_falsy
      expect(puzzle_without_creator_id_and_langauge_id.language_id).to be_falsy
      expect(puzzle_without_creator_id_and_langauge_id).to_not be_valid
    end
  end
end
