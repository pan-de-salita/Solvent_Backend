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
  has_many :comments, dependent: :destroy
  has_many :liking_users, through: :solution_likes, source: :user

  belongs_to :puzzle
  belongs_to :user
  belongs_to :language

  validates :source_code, :language_id, :puzzle_id, :user_id, presence: true
  validate :source_code_yields_expected_output

  scope :by_user, ->(user_id) { where(user_id:).order(created_at: :desc) }

  private

  def source_code_yields_expected_output
    return if Rails.env.test?

    evaluation = Judge0::Client.evaluate_source_code(source_code:, language_id:)
    return if evaluation[:status] == 200 && evaluation[:data]['stdout'] == puzzle.expected_output

    error_message = "yielded the incorrect output. stdout: #{evaluation[:data]['stdout'] || 'nil'}. stderr: #{evaluation[:data]['stderr']}"
    errors.add(:source_code, error_message)
  end
end
