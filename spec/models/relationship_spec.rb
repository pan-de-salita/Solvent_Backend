# == Schema Information
#
# Table name: relationships
#
#  id          :bigint           not null, primary key
#  follower_id :bigint           not null
#  followed_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user_one) { create :user }
  let(:user_two) { create :user }

  context 'when attributes are valid' do
    it 'creates a Relationship instance' do
      relationship = user_one.active_relationships.build(followed_id: user_two.id)
      expect(relationship).to be_valid
    end
  end

  context 'when follower is midding' do
    it 'rejects an instance creation attempt' do
      relationship = build :relationship, followed_id: user_two.id
      expect(relationship).to_not be_valid
    end
  end

  context 'when followed is midding' do
    it 'rejects an instance creation attempt' do
      relationship = build :relationship, follower_id: user_one.id
      expect(relationship).to_not be_valid
    end
  end

  it 'should follow and unfollow a user' do
    expect(user_one.following?(user_two)).to be_falsy
    user_one.follow(user_two)
    expect(user_one.following?(user_two)).to be_truthy
    expect(user_two.followers.include?(user_one)).to be_truthy
    user_one.unfollow(user_two)
    expect(user_one.following?(user_two)).to be_falsy
    user_one.follow(user_one)
    expect(user_one.following?(user_one)).to be_falsy
  end
end
