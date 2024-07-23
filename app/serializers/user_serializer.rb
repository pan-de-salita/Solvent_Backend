class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :updated_at
end
