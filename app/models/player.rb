class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  validates_presence_of :game_id, :user_id
  validates_uniqueness_of :user_id, scope: :game_id
end
