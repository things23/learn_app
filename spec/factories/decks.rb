FactoryGirl.define do
  factory :deck do
    title "Verbs"
    association :user
  end
end
