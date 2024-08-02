# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  jti                    :string           not null
#  username               :string           not null
#
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :puzzles, foreign_key: :creator_id, dependent: :destroy
  has_many :solutions, dependent: :destroy
  has_many :solved_puzzles, through: :solutions, source: :puzzle
  has_many :languages, through: :solutions
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships
  has_many :likes, dependent: :destroy
  has_many :liked_solutions, through: :likes, source: :solution

  # TODO:
  # has_many :comments, through: :solutions, dependent: :destroy
  # has_many :favorite_puzzles, through: :puzzle_favorites, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password_confirmation, presence: true, on: :create

  scope :by_solved_puzzles, lambda {
                              select('users.*, COUNT(DISTINCT puzzles.id) AS solved_puzzles_count')
                                .left_joins(:solutions, :puzzles)
                                .group('users.id')
                                .order('solved_puzzles_count DESC')
                            }

  def follow(other_user)
    following << other_user unless self == other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def leaderboard_position
    User.by_solved_puzzles.index(self) + 1
  end

  def most_used_language
    return unless language_solution_tally.present?

    most_used_language_id = language_solution_tally.max[0]
    Language.find(most_used_language_id)
  end

  def completed_solutions
    solutions.group_by { |solution| solution.puzzle.title }
  end

  private

  def language_solution_tally
    solutions.map(&:language_id).tally
  end
end
