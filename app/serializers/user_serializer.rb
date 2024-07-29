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
             :puzzles_solved, :solutions_completed, :puzzles_created, :languages_used, :stats

  attribute :following do |user|
    user.following.map(&:id)
  end
  attribute :followers do |user|
    user.followers.map(&:id)
  end
  attribute :languages_used do |user|
    user.languages
  end
  attribute :puzzles_created do |user|
    user.puzzles
  end
  attribute :solutions_completed do |user|
    user.solutions
  end
  attribute :stats do |user|
    {
      leaderboard_position: user.leaderboard_position,
      language_most_used: user.most_used_language.name
    }
  end
end
