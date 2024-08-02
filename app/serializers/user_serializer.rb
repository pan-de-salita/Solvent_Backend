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
class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :username, :email, :created_at, :updated_at, :following, :followers,
             :solved_puzzles, :completed_solutions, :languages, :created_puzzles, :stats

  attribute :following do |user|
    user.following.map(&:id)
  end
  attribute :followers do |user|
    user.followers.map(&:id)
  end
  attribute :languages do |user|
    user.languages.uniq
  end
  attribute :created_puzzles do |user|
    user.puzzles
  end
  attribute :completed_solutions do |user|
    user.completed_solutions
  end
  attribute :solved_puzzles do |user|
    user.solutions.map(&:puzzle).uniq
  end
  attribute :stats do |user|
    most_used_language_details = user.most_used_language
    most_used_language = most_used_language_details ? most_used_language_details.name : nil

    {
      leaderboard_position: user.leaderboard_position,
      most_used_language:
    }
  end
end
