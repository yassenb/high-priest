feature "signing in and out" do
  include Support::SessionHelpers

  scenario "sign in" do
    user = FactoryGirl.create(:user)
    sign_in_as user

    page.should have_content("Signed in successfully.")
    page.should have_content("Signed in as " + user.username)
    current_path.should == root_path
  end

  scenario "sign out" do
    sign_in_as FactoryGirl.create(:user)

    click_on "Sign out"
    page.should have_link("Sign in")
    current_path.should == new_user_session_path
  end

  scenario "error upon wrong e-mail or password" do
    user_with_wrong_pass = FactoryGirl.create(:user)
    user_with_wrong_pass.password = "wrongpass"

    sign_in_as(user_with_wrong_pass)

    verify_incorrect_sign_in

    user_with_wrong_email = FactoryGirl.create(:user)
    user_with_wrong_email.email = "nobody@gmail.com"

    sign_in_as(user_with_wrong_email)

    verify_incorrect_sign_in
  end

  private

  def verify_incorrect_sign_in
    page.should have_content("Invalid email or password.")
    current_path.should == new_user_session_path
  end
end
