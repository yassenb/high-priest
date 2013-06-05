feature "creating a new user" do
  scenario "create a new user" do
    user = FactoryGirl.build(:user)

    visit root_path
    click_on "Sign up"

    within "form" do
      fill_in "Username", with: user.username
      fill_in "email", with: user.email
      fill_in "Password", with: user.password
      fill_in "Confirm password", with: user.password
      click_on "Sign up"
    end

    verify_successful_sign_up user.username
  end

  scenario "error when trying to use an already taken username and creating using another one" do
    existing_user = FactoryGirl.create(:user)
    new_user = FactoryGirl.build(:user)

    visit root_path
    click_on "Sign up"

    within "form" do
      fill_in "Username", with: existing_user.username
      fill_in "email", with: new_user.email
      fill_in "Password", with: new_user.password
      fill_in "Confirm password", with: new_user.password
      click_on "Sign up"
    end

    page.should have_content("Username has already been taken")

    within "form" do
      fill_in "Username", with: new_user.username
      fill_in "Password", with: new_user.password
      fill_in "Confirm password", with: new_user.password
      click_on "Sign up"
    end

    verify_successful_sign_up new_user.username
  end

  private

  def verify_successful_sign_up(username)
    page.should have_content("Welcome! You have signed up successfully.")
    page.should have_content("Signed in as " + username)
    current_path.should == root_path
  end
end

feature "editing a user" do
  include Support::SessionHelpers

  scenario "edit a user profile" do
    user = FactoryGirl.create(:user)

    sign_in_as(user)
    visit root_path
    click_on user.username

    within "form" do
      new_pass = "secretPass123"
      fill_in "Password", with: new_pass
      fill_in "Confirm password", with: new_pass
      fill_in "Current password", with: user.password
      click_on "Update"
    end

    page.should have_content("You updated your account successfully.")
    current_path.should == root_path
  end
end
