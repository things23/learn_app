class Card < ActiveRecord::Base
  validates :original_text, presence: true, uniqueness: true
  validates :translated_text, presence: true

  before_validation :ensure_not_the_same

  protected

  def ensure_not_the_same
    if self.original_text.downcase != self.translated_text.downcase
      true
    else
      errors.add(:base, "Original text and translated must be different")
      false
    end
  end
end