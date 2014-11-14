class Card < ActiveRecord::Base
  validates :original_text, presence: true, uniqueness: true
  validates :translated_text, presence: true
  validate :original_text_cannot_be_equal_to_translated_text, on: [:create, :update]

  scope :ordered, -> { order(review_date: :asc) }
  scope :to_exercise, -> { where('review_date <= ?', Time.now) }

  def correct(translate)
    self.translated_text.mb_chars.downcase == translate.mb_chars.downcase
  end

  def review_later
    self.update(review_date: 3.days.from_now)
  end

  def original_text_cannot_be_equal_to_translated_text
    if original_text.downcase == translated_text.downcase
      errors.add(:base, "Original text and translated must be different")
    end
  end
end
