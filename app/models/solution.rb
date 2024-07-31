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
class Solution < ApplicationRecord
  has_many :solution_likes, dependent: :destroy

  # TODO:
  # has_many :likes, through: :solution_likes, source: :user
  # has_many :comments, dependent: :destroy

  belongs_to :puzzle
  belongs_to :user
  belongs_to :language

  before_validation :strip_source_code

  validates :source_code, :language_id, :puzzle_id, :user_id, presence: true
  validate :source_code_yields_expected_output

  scope :by_user, ->(user_id) { where(user_id:).order(created_at: :desc) }
  scope :recent, -> { order(created_at: :desc) }

  private

  def source_code_yields_expected_output
    return if Rails.env.test?

    begin
      evaluation = Judge0::Client.evaluate_source_code(source_code:, language_id:)
    rescue StandardError => e
      errors.add(:base, "Error evaluating source code: #{e.message}")
      return
    end

    return if evaluation[:status] == 200 && evaluation[:data]['stdout'].chomp == puzzle.expected_output

    error_message = "yielded incorrect output. stdout: #{evaluation[:data]['stdout'] || 'nil'}. stderr: #{evaluation[:data]['stderr']}"
    errors.add(:source_code, error_message)
  end

  def strip_source_code
    source_code.strip!
  end
end
