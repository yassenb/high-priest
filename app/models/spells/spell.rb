module Spells
  NSTARTING = 3

  SPELL_CLASSES = []
  SPELLS = {}
  private_constant :SPELL_CLASSES, :SPELLS

  def self.all
    SPELLS.values
  end

  class Spell
    attr_reader :id, :name

    def initialize(id)
      @id = id
    end

    def self.inherited(subclass)
      SPELL_CLASSES << subclass
    end
  end

  Dir[File.dirname(__FILE__) + "/*.rb"].each { |file| require file }

  SPELL_CLASSES.each_with_index do |klass, i|
    id = i + 1
    SPELLS[id] = klass.new(id)
  end

  module Base
    def self.included(klass)
      klass.class_exec do
        validates_inclusion_of :spell_id, in: SPELLS.keys, allow_nil: true

        define_method(:spell) do
          SPELLS[spell_id]
        end

        define_method(:spell=) do |spell|
          self.spell_id = spell.try(:id)
        end
      end
    end
  end
end
