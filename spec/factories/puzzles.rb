# == Schema Information
#
# Table name: puzzles
#
#  id          :bigint           not null, primary key
#  title       :string           not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :bigint           not null
#  creator_id  :bigint           not null
#  tags        :string           default([]), is an Array
#
FactoryBot.define do
  factory :puzzle do
    trait :with_title do
      title { 'Test Challenge' }
    end

    trait :with_description do
      description { 'Description for Test Challenge' }
    end
  end
end
