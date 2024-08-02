class OtherUserSerializer
  include JSONAPI::Serializer
  attributes :id, :username, :email, :created_at, :updated_at, :following_count, :followers_count,
             :solved_puzzles, :languages, :created_puzzles, :stats

  attribute :following_count do |user|
    user.following.count
  end
  attribute :followers_count do |user|
    user.followers.count
  end
  attribute :languages do |user|
    user.languages.uniq
  end
  attribute :created_puzzles do |user|
    user.puzzles
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
