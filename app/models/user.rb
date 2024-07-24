class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :password_confirmation, presence: true, on: :create

  # has_many :solutions
  # has_many :coauthored_solutions, through: solution_coauthors
  # has_many :puzzles, through: solutions
  # has_many :follows, foreign_key: 'follower_id'
  # has_many :followed_users, class_name: 'User', foreign_key: 'follower_id'
  # has_many :followers, class_name: 'User', foreign_key: 'followed_user_id'
  # has_many :comments, through: :solutions
  # has_many :likes
  # has_many :favorite_puzzles, through: puzzle_favorites
end
