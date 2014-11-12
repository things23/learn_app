class DifferenceValidator < ActiveModel::Validator
  def validate(record)
    if record.original_text.downcase != record.translated_text.downcase
      true
    else
      record.errors.add(:base, "Original text and translated must be different")
      false
    end
  end
end