module LoginHelper
  def sign_in
    fill_in "email", with: "info@example.com"
    fill_in "password", with: "qwerty"
    click_button "Login"
  end
end
