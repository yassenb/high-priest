class GamesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(params[:game])

    if @game.save
      flash[:notice] = "Successfully created game"
      join_game(@game)
    else
      flash[:error] = "Invalid game properties"
      render new_game_path
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  def join
    game = Game.find(params[:id])
    join_game(game)
  end

  def leave
    game = Game.find(params[:id])
    game.players.find_by_user_id(current_user).destroy
    redirect_to games_url
  end

  private

  def join_game(game)
    game.add_player current_user
    redirect_to game_url(game)
  end
end
