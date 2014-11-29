class Deck < ActiveRecord::Base
  validates :title, presence: true
  validates :user_id, presence: true
  has_many :cards, dependent: :destroy
end
