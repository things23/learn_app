class Card < ActiveRecord::Base
  validates :original_text, presence: true, uniqueness: true
  validates :translated_text, presence: true
  validates_with DifferenceValidator, only: [:create, :update]
end
