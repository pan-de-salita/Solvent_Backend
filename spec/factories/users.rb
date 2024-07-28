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
#  preferred_languages    :integer          default([]), is an Array
#
FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "testuser#{n}" }
    sequence(:email) { |n| "user#{n}@mail.com" }
    password { 'foobar' }
    password_confirmation { 'foobar' }
    jti { SecureRandom.uuid }
  end
end
