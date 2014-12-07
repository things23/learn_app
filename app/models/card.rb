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
    @translated_text = translated_text.downcase
    @transation = translation.downcase
    #check_result = @translated_text == @transation
    levenshtein_check_result = Levenshtein.distance(@translated_text, @transation)
=begin
    case levenshtein_check_result
    when 0
      handle_correct_answers
      change_review_date
      return 0
    when 1
      #TODO: something for typo
      handle_correct_answers
      change_review_date
      return 1
    else
      handle_incorrect_answers
      return false
    end
=end
    if levenshtein_check_result == 0 || levenshtein_check_result == 1
      handle_correct_answers
      change_review_date
    else
      handle_incorrect_answers
    end
    return levenshtein_check_result
    #if check_result
    #  handle_correct_answers
    #  change_review_date
    #  return true
    #else
    #  handle_incorrect_answers
    #  return false
    #end
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
end
