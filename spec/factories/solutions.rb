# == Schema Information
#
# Table name: solutions
#
#  id          :bigint           not null, primary key
#  source_code :text             default(""), not null
#  stdin       :text
#  iteration   :integer          not null
#  language_id :bigint           not null
#  puzzle_id   :bigint           not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :solution do
    
  end
end
