# frozen_string_literal: true
module Irrgarten
  require_relative 'directions'
  class FuzzyPlayer < Player
    public_class_method :new
    def initialize (other)
        super(other.getNumber, other.getIntelligence, other.getStrength)

    end

    def move(direction, validMoves)
        nueva=super.move(direction, validMoves)
        Dice.nextStep(nueva, validMoves, super.getIntelligence)
    end
    def attack
        ( Dice.intensity(getStrength + super.attack))
    end


    def defensiveEnergy
        ( Dice.intensity(getIntelligence) + super.sumShields)
    end


    def toString
        ("FUZZY" + super.toString)
    end
  end

end

