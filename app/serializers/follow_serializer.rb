class FollowSerializer
  include JSONAPI::Serializer
  attributes :id, :username, :email
end
