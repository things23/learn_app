require "rails_helper"

describe "Home page" do

  describe "when user not login" do
    before { visit root_path }
    it { expect(page).to have_link("Зарегистрируйся сейчас", href: new_user_path) }
  end

  describe "when user login" do
    let!(:user) { FactoryGirl.create(:user) }
    before(:each) do
      visit login_path
      sign_in
    end
    it { expect(page).to have_link("Logout", href: logout_path) }
    it { expect(page).to have_link("Менеджер колод", href: decks_path) }

    describe "but has not decks" do
      before { visit root_path }
      it { expect(page).to have_content("Для начала тренировок создайте колоду") }
    end

    describe "has empty decks" do
      let!(:deck) { FactoryGirl.create(:deck, user_id: user.id) }
      before { visit root_path }
      it { expect(page).to have_content("Добавьте карточек или выберете другую колоду") }
    end

    describe "has decks with cards" do
      let!(:deck) { FactoryGirl.create(:deck, user_id: user.id) }
      let!(:card) { FactoryGirl.create(:card, user_id: user.id, deck_id: deck.id) }
      before { visit root_path }

      it "checks answer" do
        fill_in "translation", with: "Тест"
        click_button "Check"
        expect(page).to have_content("Правильный ответ")
      end
    end
  end
end
