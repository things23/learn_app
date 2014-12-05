class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :deck
  before_create :set_review_date
  validates :original_text, presence: true, uniqueness: true
  validates :translated_text, :user_id, :deck_id, presence: true
  validate :original_text_cannot_be_equal_to_translated_text
  mount_uploader :image, ImageUploader

  scope :for_review, -> { where('review_date <= ?', Time.now).order("RANDOM()") }

  def check_answer(translation)
    if translated_text.mb_chars.downcase == translation.mb_chars.downcase
      calculate_correct_answers
      return true
    else
      calculate_incorrect_answers
      return false
    end
  end

  def set_review_date
    self.review_date = Time.now
  end

  def change_review_date
    case correct_answers_counter
    when 1
      update(review_date: 12.hours.from_now)
    when 2
      update(review_date: 3.days.from_now)
    when 3
      update(review_date: 1.week.from_now)
    when 4
      update(review_date: 2.weeks.from_now)
    when 5
      update(review_date: 1.month.from_now)
    end
  end

  def calculate_correct_answers
    self.incorrect_answers_counter = 0
    self.correct_answers_counter += 1
    change_review_date
  end

  def calculate_incorrect_answers
    self.incorrect_answers_counter += 1
    if self.correct_answers_counter > 1
      self.correct_answers_counter = 0
      update(review_date: 12.hours.from_now)
    else
      self.correct_answers_counter = 0
      save
    end
  end

  def original_text_cannot_be_equal_to_translated_text
    if original_text.downcase == translated_text.downcase
      errors.add(:base, "Original text and translated must be different")
    end
  end
end
