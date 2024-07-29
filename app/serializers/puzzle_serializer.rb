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
class PuzzleSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :description, :expected_output, :creator, :tags, :created_at, :updated_at, :solutions

  attribute :creator do |puzzle|
    creator = puzzle.creator
    {
      id: creator.id,
      username: creator.username,
      email: creator.email
    }
  end
end
