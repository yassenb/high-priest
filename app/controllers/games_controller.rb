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
      redirect_to game_url(@game)
    else
      flash[:error] = "Invalid game properties"
      render new_game_path
    end
  end

  def show
    @game = Game.find(params[:id])
  end
end
