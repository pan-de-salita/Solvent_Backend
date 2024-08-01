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
