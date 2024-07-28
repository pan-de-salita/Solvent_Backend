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
  attributes :id, :source_code, :output, :language, :language_id, :puzzle_title, :puzzle_description, :puzzle_id,
             :user_id

  attribute :language do |solution|
    solution.language.name
  end
  attribute :output do |solution|
    solution.puzzle.expected_output
  end
  attribute :puzzle_title do |solution|
    solution.puzzle.title
  end
  attribute :puzzle_description do |solution|
    solution.puzzle.description
  end
end
