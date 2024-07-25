# == Schema Information
#
# Table name: refactors
#
#  id          :bigint           not null, primary key
#  source_code :text             default(""), not null
#  description :text             default(""), not null
#  accepted?   :boolean          default(FALSE), not null
#  solution_id :bigint           not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Refactor < ApplicationRecord
end
