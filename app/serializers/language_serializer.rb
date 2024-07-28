class LanguageSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :version
end
