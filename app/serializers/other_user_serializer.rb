class OtherUserSerializer
  include JSONAPI::Serializer
  attributes :id, :username, :email, :preferred_languages, :created_at, :updated_at, :following, :followers,
             :puzzles_solved, :puzzles_created, :languages_used, :stats

  attribute :following do |user|
    user.following.count
  end
  attribute :followers do |user|
    user.followers.count
  end
  attribute :languages_used do |user|
    user.languages
  end
  attribute :puzzles_created do |user|
    user.puzzles
  end
  attribute :stats do |user|
    {
      leaderboard_position: user.leaderboard_position,
      language_most_used: user.most_used_language.name
    }
  end
end
