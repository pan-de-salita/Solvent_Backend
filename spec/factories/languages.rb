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
FactoryBot.define do
  factory :language do
    name { 'Some Lang' }
  end
end
