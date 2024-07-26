# == Schema Information
#
# Table name: follows
#
#  id          :bigint           not null, primary key
#  follower_id :bigint           not null
#  followee_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :relationship do
  end
end
