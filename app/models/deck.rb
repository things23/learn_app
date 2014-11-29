class Deck < ActiveRecord::Base
  validates :title, :user_id, presence: true
  has_many :cards, dependent: :destroy
end
