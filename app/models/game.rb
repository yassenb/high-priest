class Game < ActiveRecord::Base
  has_many :players, dependent: :destroy

  attr_accessible :name

  validates_presence_of :name, :created_at

  default_scope order("created_at DESC")

  before_validation do |game|
    game.created_at ||= Time.now
  end

  def add_player(user)
    self.players << Player.new { |p| p.user = user }
  end

  def users
    self.players.map { |player| player.user }
  end
end
