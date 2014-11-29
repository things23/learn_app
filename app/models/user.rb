class User < ActiveRecord::Base
  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validates :email, presence: true, uniqueness: true
  has_many :cards, dependent: :destroy
  has_many :decks, dependent: :destroy
  has_many :authentications, dependent: :destroy
  belongs_to :current_deck, class_name:"Deck", foreign_key: "current_deck_id"
  accepts_nested_attributes_for :authentications
  authenticates_with_sorcery!
end
