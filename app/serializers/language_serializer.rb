# == Schema Information
#
# Table name: languages
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  version    :string
#
class LanguageSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :version
end
