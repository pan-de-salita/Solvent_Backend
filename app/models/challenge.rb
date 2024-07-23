# frozen_string_literal: true

class Challenge < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :start_date, presence: true, comparison: { greater_than_or_equal_to: Date.today }
  validates :end_date, presence: true, comparison: { greater_than: Date.today }
end
