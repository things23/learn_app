class User < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
end
