feature "managing games" do
  include Support::SessionHelpers

  background do
    @user = FactoryGirl.create(:user)
    sign_in_as @user
  end

  scenario "create a game" do
    game = FactoryGirl.attributes_for(:game)

    visit root_path
    click_on "New Game"

    within "form" do
      fill_in "Name", with: game[:name]
      click_on "Create Game"
    end

    page.should have_content("Successfully created game")
    current_path.should start_with(game_path(""))
    find("#players").should have_content(@user.username)
  end

  scenario "show a game" do
    game = FactoryGirl.create(:game)

    visit games_path
    click_on game.name

    current_path.should == game_path(game)
    page.should have_content(game.name)
  end

  scenario "list all games with newest on top" do
    game = FactoryGirl.attributes_for(:game)
    older_game = FactoryGirl.attributes_for(:game, { created_at: 1.hour.ago })

    [game, older_game].permutation do |games|
      Game.destroy_all
      games.each { |game| Game.create(game, without_protection: true) }

      visit root_path
      click_on "Games"

      all("tr").map(&:text).should == [game[:name], older_game[:name]]
    end
  end

  scenario "join a game" do
    game = FactoryGirl.create(:game_with_creator)
    another_user = FactoryGirl.create(:user)

    sign_in_as another_user, true
    visit games_path
    Support::SelectorHelpers.row_of(find("td", text: game.name)).find_button("join").click

    current_path.should == game_path(game)
    find("#players").should have_content(another_user.username)
  end

  scenario "leave a game" do
    game = FactoryGirl.create(:game)
    user = FactoryGirl.create(:user)
    game.add_player user
    another_user = FactoryGirl.create(:user)
    game.add_player another_user

    sign_in_as user, true
    visit game_path(game)
    click_on "leave"

    current_path.should == games_path

    sign_in_as another_user, true
    visit game_path(game)
    find("#players").should_not have_content(user.username)
  end

  # the test should cover the before_filter for authenticated user for the whole application
  scenario "try to show a game when not authenticated" do
    game = FactoryGirl.create(:game)

    click_on "Sign out"
    visit game_path(game)

    page.should have_content("You need to sign in or sign up before continuing")

    sign_in_as @user

    current_path.should == game_path(game)
  end
end
