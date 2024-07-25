# == Schema Information
#
# Table name: comments
#
#  id          :bigint           not null, primary key
#  content     :text             not null
#  solution_id :bigint           not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Comment < ApplicationRecord
end
