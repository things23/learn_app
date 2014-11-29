require 'rails_helper'

describe Deck do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:deck) { FactoryGirl.create(:deck, user_id: user.id) }

  subject { deck }

  it { is_expected.to respond_to(:user_id) }
end
