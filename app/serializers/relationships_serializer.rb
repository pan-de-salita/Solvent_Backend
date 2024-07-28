class RelationshipsSerializer
  include JSONAPI::Serializer
  attributes :follower, :following
  attribute :follower do |relationship|
    User.find(relationship.follower_id)
  end
  attribute :follower do |relationship|
    User.find(relationship.followed_id)
  end
end
