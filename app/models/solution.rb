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
class Solution < ApplicationRecord
  has_many :refactors, dependent: :destroy
  has_many :solution_likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :solution_coauthors, dependent: :destroy
  has_many :liking_users, through: :solution_likes, source: :user
  belongs_to :puzzle
  belongs_to :user
  belongs_to :language

  validates :source_code, :language_id, :puzzle_id, :user_id, presence: true
  validates :iteration, presence: true, comparison: { greater_than_or_equal_to: 1 }
  validate :iteration_must_be_sequential

  private

  def iteration_must_be_sequential
    last_iteration = Solution.where(user_id:, puzzle_id:)
                             .order(iteration: :desc)
                             .limit(1)
                             .pluck(:iteration)
                             .first
    return unless last_iteration && iteration != last_iteration + 1

    errors.add(:iteration, 'must be sequential')
  end
end
