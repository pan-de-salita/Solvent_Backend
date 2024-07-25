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
class PuzzleSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :description, :language_id, :creator_id, :tags, :created_at, :updated_at
  attribute :language do |puzzle|
    puzzle.language.name
  end
  attribute :creator do |puzzle|
    puzzle.creator.username
  end
end
