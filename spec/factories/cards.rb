FactoryGirl.define do
  factory :card do
    original_text "Test"
    translated_text "Тест"
    review_date Time.now
    correct_answers_counter 0
    incorrect_answers_counter 0
    ef 2.5
    interval 1.0
    association :user
    association :deck

    factory :card_withount_original_text do
      original_text " "
    end

    factory :card_withount_translated_text do
      translated_text " "
    end
  end
end
