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
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :puzzles, foreign_key: :creator_id, dependent: :destroy
  has_many :solutions, dependent: :destroy
  has_many :languages, through: :solutions

  # has_many :relationships, foreign_key: 'follower_id', dependent: :destroy
  # has_many :followed_users, class_name: 'User', foreign_key: :follower_id
  # has_many :followers, class_name: 'User', foreign_key: :followed_user_id, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy

  has_many :comments, through: :solutions, dependent: :destroy

  has_many :solution_likes, dependent: :destroy
  has_many :liked_solutions, through: :solution_likes, source: :solution
  has_many :favorite_puzzles, through: :puzzle_favorites, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password_confirmation, presence: true, on: :create
  validate :preferred_languages_must_be_an_array_of_language_ids

  private

  def preferred_languages_must_be_an_array_of_language_ids
    if preferred_languages.present? &&
       preferred_languages.any? { |preferred_language| Language.where(id: preferred_language).empty? }
      errors.add(:preferred_languages, 'must be an array of language_ids')
    end
  end
end
