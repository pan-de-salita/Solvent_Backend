# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  jti                    :string           not null
#  username               :string           not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:lang_one) { create :language, name: 'Lang One', id: 1 }
  let!(:lang_two) { create :language, name: 'Lang Two', id: 2 }
  let!(:lang_three) { create :language, name: 'Lang Three', id: 3 }
  let!(:user) { build :user }

  context 'when attributes are valid' do
    it 'creates a User instance' do
      expect(user).to be_valid
    end
  end

  context 'when password_confirmation is blank' do
    it 'rejects an instance creation attempt' do
      user.password_confirmation = nil
      expect(user.password_confirmation).to be_falsy
      expect(user).to_not be_valid
    end
  end

  context 'when email is blank' do
    it 'rejects an instance creation attempt' do
      blank_emails = ['', '   ', nil]

      blank_emails.each do |blank_email|
        user.email = blank_email
        expect(user.email).to be_blank
        expect(user).to_not be_valid
      end
    end
  end

  context 'when an existing email is used' do
    it 'rejects an instance creation attempt' do
      user_with_duplicate_email = user.dup
      user.save
      expect(user_with_duplicate_email.email).to eq(user.email)
      expect(user_with_duplicate_email).to_not be_valid
    end
  end

  context 'when an existing username is used' do
    it 'rejects an instance creation attempt' do
      user_with_duplicate_username = user.dup
      user.save
      expect(user_with_duplicate_username.username).to eq(user.username)
      expect(user_with_duplicate_username).to_not be_valid
    end
  end
end
