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
require 'rails_helper'

RSpec.describe Comment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
