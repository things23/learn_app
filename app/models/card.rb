class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :deck
  before_create :set_review_date, :downcase_translated_text
  validates :original_text, presence: true, uniqueness: true
  validates :translated_text, :user_id, :deck_id, presence: true
  validate :original_text_cannot_be_equal_to_translated_text
  mount_uploader :image, ImageUploader

  scope :for_review, -> { where('review_date <= ?', Time.now).order("RANDOM()") }

  def check_answer(translation)
    levenshtein_check_result = Levenshtein.distance(translated_text, translation)

    if levenshtein_check_result == 0 || levenshtein_check_result == 1
      handle_correct_answers
      change_review_date
    else
      handle_incorrect_answers
    end
    levenshtein_check_result
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

  def handle_correct_answers
    self.incorrect_answers_counter = 0
    increment(:correct_answers_counter)
  end

  def handle_incorrect_answers
    increment(:incorrect_answers_counter)
    if self.correct_answers_counter > 1
      self.review_date = 12.hours.from_now
    end
    self.correct_answers_counter = 0
    save
  end

  def original_text_cannot_be_equal_to_translated_text
    if original_text.downcase == translated_text.downcase
      errors.add(:base, "Original text and translated must be different")
    end
  end

  def set_review_date
    self.review_date = Time.now
  end

  def downcase_translated_text
    self.translated_text= translated_text.mb_chars.downcase.to_s
  end
end
