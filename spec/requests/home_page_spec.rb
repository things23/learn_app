require "rails_helper"

describe "Home page" do

  let!(:user) { FactoryGirl.create(:user) }

  before(:each) do
    visit login_path
    sign_in(user)
  end
  let!(:card) { FactoryGirl.create(:card, user: user)  }
  it "checks answer" do
    visit root_path
    fill_in "translation", with: "Тест"
    click_button "Check"
    expect(page).to have_content("Правильный ответ")
  end
end
