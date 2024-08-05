# == Schema Information
#
# Table name: solutions
#
#  id          :bigint           not null, primary key
#  source_code :text             default(""), not null
#  language_id :bigint           not null
#  puzzle_id   :bigint           not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class SolutionSerializer
  include JSONAPI::Serializer
  attributes :id, :source_code, :user_id, :language, :puzzle, :likers, :created_at, :updated_at

  attribute :likers do |solution|
    solution.likers.map(&:username)
  end
end
