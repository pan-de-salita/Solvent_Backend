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
class Puzzle < ApplicationRecord
  has_many :solutions, dependent: :destroy
  has_many :users, through: :solutions

  # TODO:
  # has_many :puzzle_favorites, dependent: :destroy

  belongs_to :creator, class_name: 'User'

  before_validation :format_expected_output

  validates :title, presence: true, uniqueness: true
  validates :description, :creator_id, :expected_output, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def solutions_by_languages
    solutions.group_by { |solution| solution.language.name }
  end

  private

  def format_expected_output
    self.expected_output = "#{expected_output.strip}\n" unless expected_output.end_with?("\n")
  end
end
