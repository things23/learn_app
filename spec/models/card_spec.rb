
require "rails_helper"

describe Card do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:deck) { FactoryGirl.create(:deck, user_id: user.id) }
  let!(:card) { FactoryGirl.create(:card, user_id: user.id, deck_id: deck.id) }
  subject { card }

  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:deck_id) }

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
      expect(card.check_answer(translation)).to be false
    end
    it "is right answer " do
      translation = "Тест"
      expect(card.check_answer(translation)).to be true
    end
  end

  describe "#change_review_date" do
    let!(:card) { FactoryGirl.create(:card, original_text: "testtest", user_id: user.id, deck_id: deck.id) }
    before(:each) { Timecop.freeze }

    context "first correct answer" do
      it "change review date to 12 hours from now" do
        card.correct_answers_counter = 1
        expect { card.change_review_date }.to change { card.review_date }.to(12.hours.from_now)
      end
    end

    context "second correct answer" do
      it "change review date to three days from now" do
        card.correct_answers_counter = 2
        expect { card.change_review_date }.to change { card.review_date }.to(3.days.from_now)
      end
    end

    context "third correct answer" do
      it "change review date to 1 week from now" do
        card.correct_answers_counter = 3
        expect { card.change_review_date }.to change { card.review_date }.to(1.week.from_now)
      end
    end

    context "fourth correct answer" do
      it "change review date to 2 weeks from now" do
        card.correct_answers_counter = 4
        expect { card.change_review_date }.to change { card.review_date }.to(2.weeks.from_now)
      end
    end

    context "fifth correct answer to 1 month from now" do
      it "change review date" do
        card.correct_answers_counter = 5
        expect { card.change_review_date }.to change { card.review_date }.to(1.month.from_now)
      end
    end
  end

  describe "#calculate_correct_answers" do
    it { expect { card.calculate_correct_answers }.to change { card.correct_answers_counter }.by(1) }
  end

  describe "#calculate_incorrect_answers" do
    context "when user has correct answers" do
      it "change review date to 12 hours from now" do
        Timecop.freeze
        card.correct_answers_counter = 3
        expect { card.calculate_incorrect_answers }.to change { card.review_date }.to(12.hours.from_now)
      end
    end

    context "when user has not correct answers" do
      it { expect { card.calculate_incorrect_answers }.to change { card.incorrect_answers_counter }.by(1) }
    end
  end
end
