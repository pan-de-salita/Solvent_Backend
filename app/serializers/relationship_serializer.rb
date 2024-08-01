# == Schema Information
#
# Table name: relationships
#
#  id          :bigint           not null, primary key
#  follower_id :bigint           not null
#  followed_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class RelationshipSerializer
  include JSONAPI::Serializer
  attributes :id, :follower, :followed

  attribute :follower do |relationship|
    follower = relationship.follower
    {
      id: follower.id,
      username: follower.username,
      email: follower.email
    }
  end
  attribute :followed do |relationship|
    followed = relationship.followed
    {
      id: followed.id,
      username: followed.username,
      email: followed.email
    }
  end
end
