class Game < ActiveRecord::Base
  attr_accessible :name

  validates_presence_of :name, :created_at

  default_scope order("created_at DESC")

  before_validation do |game|
    game.created_at ||= Time.now
  end
end
