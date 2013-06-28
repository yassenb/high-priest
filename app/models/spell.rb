require "spells/spell"

class Spell < ActiveRecord::Base
  include Spells::Base

  belongs_to :player

  validates_presence_of :player_id, :spell_id
end
