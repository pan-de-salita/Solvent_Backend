# == Schema Information
#
# Table name: solutions
#
#  id          :bigint           not null, primary key
#  source_code :text             default(""), not null
#  stdin       :text
#  iteration   :integer          not null
#  language_id :bigint           not null
#  puzzle_id   :bigint           not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Solution, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
