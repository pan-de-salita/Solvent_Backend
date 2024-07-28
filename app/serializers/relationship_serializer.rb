class RelationshipSerializer
  include JSONAPI::Serializer
  attributes :id, :follower, :following

  attribute :follower do |relationship|
    UserSerializer.new(relationship.follower).serializable_hash[:data][:attributes]
  end

  attribute :following do |relationship|
    UserSerializer.new(relationship.followed).serializable_hash[:data][:attributes]
  end
end
