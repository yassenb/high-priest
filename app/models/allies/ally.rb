module Allies
  NSTARTING = 3

  ALLY_CLASSES = []
  ALLIES = {}
  private_constant :ALLY_CLASSES, :ALLIES

  def self.all
    ALLIES.values
  end

  class Ally
    attr_reader :id, :name

    def initialize(id)
      @id = id
    end

    def self.inherited(subclass)
      ALLY_CLASSES << subclass
    end
  end

  Dir[File.dirname(__FILE__) + "/*.rb"].each { |file| require file }

  ALLY_CLASSES.each_with_index do |klass, i|
    id = i + 1
    ALLIES[id] = klass.new(id)
  end

  module Base
    def self.included(klass)
      klass.class_exec do
        validates_inclusion_of :ally_id, in: ALLIES.keys, allow_nil: true

        define_method(:ally) do
          ALLIES[ally_id]
        end

        define_method(:ally=) do |ally|
          self.ally_id = ally.try(:id)
        end
      end
    end
  end
end
