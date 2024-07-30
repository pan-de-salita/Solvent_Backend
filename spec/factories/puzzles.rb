# == Schema Information
#
# Table name: puzzles
#
#  id              :bigint           not null, primary key
#  title           :string           not null
#  description     :text             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  creator_id      :bigint           not null
#  tags            :string           default([]), is an Array
#  expected_output :text             not null
#
FactoryBot.define do
  factory :puzzle do
    sequence(:title) { |n| "Test Challenge #{n}" }
    sequence(:description) { |n| "Description for Test Challenge #{n}" }
    sequence(:expected_output) { |n| " Expected output for Test Challenge #{n}  " }
  end
end
