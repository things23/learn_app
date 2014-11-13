class Card < ActiveRecord::Base
  validates :original_text, presence: true, uniqueness: true
  validates :translated_text, presence: true
  validate :original_text_cannot_be_equal_to_translated_text, on: [:create, :update]

  def original_text_cannot_be_equal_to_translated_text
    if original_text.downcase == translated_text.downcase
      errors.add(:base, "Original text and translated must be different")
    end
  end
end
