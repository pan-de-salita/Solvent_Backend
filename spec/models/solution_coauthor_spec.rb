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
require 'rails_helper'

RSpec.describe SolutionCoauthor, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
