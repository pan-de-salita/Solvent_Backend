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
require 'rails_helper'

RSpec.describe Refactor, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
