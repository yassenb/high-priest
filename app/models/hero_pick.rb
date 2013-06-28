require "heroes/hero"

class HeroPick < ActiveRecord::Base
  NPICKS = 3

  include Heroes::Base

  belongs_to :player

  validates_presence_of :player_id, :hero_id
  validates_uniqueness_of :hero_id, scope: :player_id
end
