require 'rails_helper'

describe Card do
  #before { @card = Card.new(original_text: "test", translated_text: "тест", review_date: "17/04/2014" )}
  let(:card) { FactoryGirl.create(:card, original_text: "lorem ipsum") }

  subject { card }

  it { is_expected.to be_valid }
  it { is_expected.to respond_to(:original_text) }
  it { is_expected.to respond_to(:translated_text)}
  it { is_expected.to respond_to(:review_date)}

  describe "#translated_text" do
    let(:card) { FactoryGirl.build(:card, original_text: "original", translated_text: "original") }
    context "can't be equal to original_text" do
      it { is_expected.not_to be_valid }
    end
  end

  describe "uniqueness" do
    it "has unique original_text" do
      card = FactoryGirl.build(:card, original_text: "unique original text")
      dup_card = FactoryGirl.create(:card, original_text: "unique original text")
      card.should_not be_valid
    end
  end

  describe "presence of attribute" do
    context "has not original_text" do
      let(:card) { FactoryGirl.build(:card_withount_original_text)  }
      it { is_expected.not_to be_valid }
    end
    context "has not translated_text" do
      let(:card) { FactoryGirl.build(:card_withount_translated_text)  }
      it { is_expected.not_to be_valid }
    end
  end

  describe ".change_review_date" do
    let(:card) { FactoryGirl.create(:card, original_text: "test test test", ) }
    it "change review date" do
      @three_days_from_now = card.review_date + 3.days
      expect { card.change_review_date }.to change { card.review_date }.to(@three_days_from_now)
    end
  end

  describe ".check_answer" do
    let(:card) { FactoryGirl.build(:card) }
    it "is wrong answer" do
      translation = "Тdт"
      expect(card.check_answer(translation)).to be false
    end
    it "is right answer " do
      translation = "Тест"
      expect(card.check_answer(translation)).to be true
    end
  end
end