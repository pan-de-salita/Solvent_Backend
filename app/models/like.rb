# == Schema Information
#
# Table name: likes
#
#  id          :bigint           not null, primary key
#  user_id     :bigint           not null
#  solution_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :solution

  validates :user_id, presence: true
  validates :solution_id, presence: true
end
