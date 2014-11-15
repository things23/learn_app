require 'rails_helper'

RSpec.describe Card, :type => :model do
  before { @card = Card.new(original_text: "test", translated_text: "тест", review_date: "2012-12-12") }

  subject { @card }

  it { should be_valid }
  it { should respond_to( :original_text )}
  it { should respond_to( :translated_text )}

  describe "when original_text is not presence" do
    before { @card.original_text = "" }
    it { should_not be_valid }
  end

  describe "when translated_text is not presence" do
    before { @card.translated_text = "" }
    it { should_not be_valid }
  end

  describe "original text and translated text can't be equal" do
    before do
     @card.original_text = "test"
     @card.translated_text = "test"
   end
   it { should_not be_valid}
 end

 describe "cards can't be dublicated" do
  before do
    cards_with_same_original_text = @card.dup
    cards_with_same_original_text.save
  end

  it { should_not be_valid }
 end
end
