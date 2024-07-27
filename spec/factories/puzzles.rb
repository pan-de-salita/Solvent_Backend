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
    title { 'Test Challenge' }
    description { 'Description for Test Challenge' }
    expected_output { 'Expected output for Test Challenge' }
  end
end
