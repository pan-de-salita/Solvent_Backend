# == Schema Information
#
# Table name: solution_coauthors
#
#  id          :bigint           not null, primary key
#  user_id     :bigint           not null
#  solution_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class SolutionCoauthor < ApplicationRecord
end
