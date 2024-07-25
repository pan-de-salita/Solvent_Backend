# == Schema Information
#
# Table name: puzzle_favorites
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  puzzle_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PuzzleFavorite < ApplicationRecord
end
