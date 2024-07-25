FactoryBot.define do
  factory :user do
    username { 'test_user' }
    email { 'test@mail.com' }
    password { 'foobar' }
    password_confirmation { 'foobar' }
    jti { SecureRandom.uuid }
  end
end
