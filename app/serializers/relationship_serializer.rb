class RelationshipSerializer
  include JSONAPI::Serializer
  attributes :id, :follower, :followed

  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
end
