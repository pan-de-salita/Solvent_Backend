class OtherUserSerializer
  include JSONAPI::Serializer
  attributes :id, :username, :email, :preferred_languages, :created_at, :updated_at, :following_count, :followers_count,
             :puzzles_solved, :puzzles_created, :languages_used, :stats

  attribute :following_count do |user|
    user.following.count
  end
  attribute :followers_count do |user|
    user.followers.count
  end
  attribute :languages_used do |user|
    user.languages
  end
  attribute :puzzles_created do |user|
    user.puzzles
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
