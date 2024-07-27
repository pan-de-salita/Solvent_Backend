# == Schema Information
#
# Table name: solutions
#
#  id          :bigint           not null, primary key
#  source_code :text             default(""), not null
#  iteration   :integer          not null
#  language_id :bigint           not null
#  puzzle_id   :bigint           not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :solution do
    source_code { '((0...1000).step(3).to_a | (0...1000).step(5).to_a).sum' }
  end
end
