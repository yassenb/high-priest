module Heroes
  HERO_CLASSES = []
  HEROES = {}
  private_constant :HERO_CLASSES, :HEROES

  def self.all
    HEROES.values
  end

  class Hero
    attr_reader :id, :name

    def initialize(id)
      @id = id
    end

    def self.inherited(subclass)
      HERO_CLASSES << subclass
    end
  end

  Dir[File.dirname(__FILE__) + "/*.rb"].each { |file| require file }

  HERO_CLASSES.each_with_index do |klass, i|
    id = i + 1
    HEROES[id] = klass.new(id)
  end

  module Base
    def self.included(klass)
      klass.class_exec do
        validates_inclusion_of :hero_id, in: HEROES.keys, allow_nil: true

        define_method(:hero) do
          HEROES[hero_id]
        end

        define_method(:hero=) do |hero|
          self.hero_id = hero.try(:id)
        end
      end
    end
  end
end
