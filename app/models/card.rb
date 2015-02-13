class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :deck
  before_create :set_default_review_date, :downcase_translated_text
  validates :original_text, presence: true
  validates :translated_text, :user_id, :deck_id, presence: true
  validate :original_text_cannot_be_equal_to_translated_text
  mount_uploader :image, ImageUploader

  scope :for_review, -> { where('review_date <= ?', Time.now).order("RANDOM()") }

  def check_answer(translation, time)
    translation = translation.mb_chars.downcase.to_s
    levenshtein_check_result = Levenshtein.distance(translated_text, translation)
    if [0, 1].include?(levenshtein_check_result)
      handle_correct_answers
    else
      handle_incorrect_answers
    end
    change_review_date(levenshtein_check_result, time)
    levenshtein_check_result
  end

  def change_review_date(typo, time)
    super_memo = SuperMemo.new(interval, correct_answers_counter, ef, time, typo)
    update_attributes(interval: super_memo.interval,
                      ef: super_memo.ef,
                      review_date: super_memo.interval.days.from_now)
  end

  def handle_correct_answers
    self.incorrect_answers_counter = 0
    increment(:correct_answers_counter)
    save
  end

  def handle_incorrect_answers
    self.correct_answers_counter = 0
    increment(:incorrect_answers_counter)
    save
  end

  def original_text_cannot_be_equal_to_translated_text
    if original_text.downcase == translated_text.downcase
      errors.add(:base, "Original text and translated must be different")
    end
  end

  def set_default_review_date
    self.review_date = Time.now
  end

  def downcase_translated_text
    self.translated_text = translated_text.mb_chars.downcase.to_s
  end
end
