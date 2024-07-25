# frozen_string_literal: true

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
class Puzzle < ApplicationRecord
  belongs_to :language
  belongs_to :creator, class_name: 'User'

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :creator_id, presence: true
  validates :creator_id, presence: true
end
