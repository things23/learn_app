require 'rails_helper'

describe User do
  let(:user) {FactoryGirl.create(:user)}

  it { is_expected.to respond_to(:cards) }
end
