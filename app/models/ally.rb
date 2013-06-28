require "allies/ally"

class Ally < ActiveRecord::Base
  include Allies::Base

  belongs_to :player

  validates_presence_of :player_id, :ally_id
end
