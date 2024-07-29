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
             :solved_puzzles, :completed_solutions, :created_puzzles, :used_languages, :stats

  attribute :following do |user|
    user.following.map(&:id)
  end
  attribute :followers do |user|
    user.followers.map(&:id)
  end
  attribute :used_languages do |user|
    user.languages
  end
  attribute :created_puzzles do |user|
    user.puzzles
  end
  attribute :completed_solutions do |user|
    user.solutions
  end
  attribute :solved_puzzles do |user|
    user.solutions.map(&:puzzle).uniq
  end
  attribute :stats do |user|
    {
      leaderboard_position: user.leaderboard_position,
      most_used_language: user.most_used_language.name
    }
  end
end
