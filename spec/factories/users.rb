FactoryGirl.define do
  factory :user do
    email "info@example.com"
    password "qwerty"
    password_confirmation "qwerty"

    factory :user_with_current_deck do
      current_deck_id 1
    end
  end
end
