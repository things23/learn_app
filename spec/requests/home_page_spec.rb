require "rails_helper"

describe "Home page" do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:card) { FactoryGirl.create(:card, user: user)  }
  before(:each) do
    visit login_path
    fill_in "email", with: "info@example.com"
    fill_in "password", with: "qwerty"
    click_button "Login"
  end

  it "checks answer" do
    fill_in "translation", with: "Тест"
    click_button "Check"
    expect(page).to have_content("Правильный ответ")
  end
end
