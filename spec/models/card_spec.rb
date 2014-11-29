
require "rails_helper"

describe Card do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:deck) { FactoryGirl.create(:deck, user_id: user.id) }
  let!(:card) { FactoryGirl.create(:card, user_id: user.id, deck_id: deck.id)}
  subject { card }

  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:deck_id) }

  describe "translated_text" do
    let!(:card) { FactoryGirl.build(:card, original_text: "original", translated_text: "original",  user_id: user.id, deck_id: deck.id)}
    it "can't be equal to original_text" do
      is_expected.not_to be_valid
    end
  end

  describe "uniqueness" do
    let!(:user) { FactoryGirl.create(:user, email: "xmpl@xmpl.com") }
    let!(:deck) { FactoryGirl.create(:deck, user_id: user.id) }
    it "has unique original_text" do
      card = FactoryGirl.build(:card, deck_id: deck.id, user_id: user.id, original_text: "unique original text")
      FactoryGirl.create(:card, deck_id: deck.id, user_id: user.id, original_text: "unique original text")
      expect(card).not_to be_valid
    end
  end

  describe "presence of attribute" do
    context "has not original_text" do
      let(:card) { FactoryGirl.build(:card_withount_original_text, deck_id: deck.id, user_id: user.id) }
      it { is_expected.not_to be_valid }
    end
    context "has not translated_text" do
      let(:card) { FactoryGirl.build(:card_withount_translated_text, deck_id: deck.id, user_id: user.id) }
      it { is_expected.not_to be_valid }
    end
  end

  describe "#change_review_date" do
    let!(:card) { FactoryGirl.create(:card, original_text: "test test test", user_id: user.id, deck_id: deck.id)}
    it "change review date" do
      @three_days_from_now = card.review_date + 3.days
      expect { card.change_review_date }.to change { card.review_date }.to(@three_days_from_now)
    end
  end

  describe "#check_answer" do
    it "is wrong answer" do
      translation = "wrong"
      expect(card.check_answer(translation)).to be false
    end
    it "is right answer " do
      translation = "Тест"
      expect(card.check_answer(translation)).to be true
    end
  end
end
