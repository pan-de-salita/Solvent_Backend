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
#  preferred_languages    :integer          default([]), is an Array
#
class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :username, :email, :preferred_languages, :created_at, :updated_at, :following, :followers,
             :languages, :puzzles, :solutions, :stats

  has_many :languages
  has_many :puzzles, foreign_key: :creator_id
  has_many :solutions

  attribute :following do |user|
    user.following.map(&:id)
  end
  attribute :followers do |user|
    user.followers.map(&:id)
  end
  attribute :stats do |user|
    {
      leaderboard_position: user.leaderboard_position,
      total_puzzles_solved: user.solved_solutions.count,
      total_solutions_completed: user.solutions.count,
      total_languages_used: user.languages.count,
      language_most_used: user.most_used_language.name
    }
  end
end
