module Support
  module SessionHelpers
    def sign_in_as(user, sign_out_first = false)
      visit root_path unless current_path
      click_on "Sign out" if sign_out_first
      click_on "Sign in" unless current_path == new_user_session_path

      within "form" do
        fill_in "email", with: user.email
        fill_in "password", with: user.password
        click_on "Sign in"
      end
    end
  end
end
