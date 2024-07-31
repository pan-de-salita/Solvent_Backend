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
