# encoding: utf-8
require 'rails_helper'
require 'spec_helper'

describe "Home page" do

  let!(:card) { FactoryGirl.create(:card)}
  before(:each) { visit root_path }

  it "has logo" do
    expect(page).to have_content("Флэшкарточкер")
  end

  it "checks answer" do
    fill_in "translation", with: "Тест"
    click_button "Check"
    expect(page).to have_content("Правильный ответ")
  end
end
