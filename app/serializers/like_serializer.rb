# == Schema Information
#
# Table name: likes
#
#  id          :bigint           not null, primary key
#  user_id     :bigint           not null
#  solution_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class LikeSerializer
  include JSONAPI::Serializer
  attributes :id, :liker, :solution

  attribute :liker do |like|
    liker = like.user
    {
      id: liker.id,
      username: liker.username
    }
  end
end
