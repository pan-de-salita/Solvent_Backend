# frozen_string_literal: true

class Challenge < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
