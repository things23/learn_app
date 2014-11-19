# encoding: utf-8
require "rails_helper"

describe "Home page" do

  let!(:card) { FactoryGirl.create(:card) }
  before(:each) { visit root_path }

  it "checks answer" do
    fill_in "translation", with: "right"
    click_button "Check"
    expect(page).to have_content("Правильный ответ")
  end
end
