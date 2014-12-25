
require "rails_helper"

describe Card do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:deck) { FactoryGirl.create(:deck, user_id: user.id) }
  let!(:card) { FactoryGirl.create(:card, user_id: user.id, deck_id: deck.id) }
  subject { card }

  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:deck_id) }

  before { @time = 30.seconds }

  describe "translated_text" do
    let!(:card) { FactoryGirl.build(:card, original_text: "original", translated_text: "original",  user_id: user.id, deck_id: deck.id) }
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

  describe "#check_answer" do
    it "is wrong answer" do
      translation = "wrong"
      expect(card.check_answer(translation, @time)).to eq(5)
    end
    it "is right answer " do
      translation = "тест"
      expect(card.check_answer(translation, @time)).to eq(0)
    end
  end

  describe "#change_review_date" do
    let!(:card) { FactoryGirl.create(:card, original_text: "testtest", user_id: user.id, deck_id: deck.id) }
    before(:each) { Timecop.freeze }

    context "first correct answer" do
      it "change review date to 1 day from now" do
        card.correct_answers_counter = 1
        expect { card.change_review_date(0, @time) }.to change { card.review_date }.to(1.days.from_now)
      end
    end

    context "second correct answer" do
      it "change review date to 6 days from now" do
        card.correct_answers_counter = 2
        expect { card.change_review_date(0, @time) }.to change { card.review_date }.to(6.days.from_now)
      end
    end

    context "third correct answer" do
      it "change review date to appropriate for ef" do
        card.interval = 6.0
        card.ef = 2.2
        card.correct_answers_counter = 3
        expect { card.change_review_date(0, @time) }.to change { card.review_date }.to(12.days.from_now)
      end
    end
  end

  describe "#handle_correct_answers" do
    it { expect { card.handle_correct_answers }.to change { card.correct_answers_counter }.by(1) }
  end

  describe "#handle_incorrect_answers" do
    it { expect { card.handle_incorrect_answers }.to change { card.incorrect_answers_counter }.by(1) }
  end
end
