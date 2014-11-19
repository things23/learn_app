class Card < ActiveRecord::Base
  belongs_to :user
  validates :original_text, presence: true, uniqueness: true
  validates :translated_text, presence: true
  validate :original_text_cannot_be_equal_to_translated_text
  validates :user_id, presence: true

  scope :for_review, -> { where('review_date <= ?', Time.now).order("RANDOM()") }

  def check_answer(translation)
    translated_text.mb_chars.downcase == translation.mb_chars.downcase
  end

  def change_review_date
    update(review_date: 3.days.from_now)
  end

  def original_text_cannot_be_equal_to_translated_text
    if original_text.downcase == translated_text.downcase
      errors.add(:base, "Original text and translated must be different")
    end
  end
end
