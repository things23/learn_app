class DifferenceValidator < ActiveModel::Validator
  def validate(record)
    if record.original_text.downcase == record.translated_text.downcase
      record.errors.add(:base, "Original text and translated must be different")
    end
  end
end

class Card < ActiveRecord::Base
  validates :original_text, presence: true, uniqueness: true
  validates :translated_text, presence: true
  validates_with DifferenceValidator, only: [:create, :update]
end
