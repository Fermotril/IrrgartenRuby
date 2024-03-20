# frozen_string_literal: true
require_relative 'dice'
require_relative 'labyrinth_character'
module Irrgarten

  class Monster < LabyrinthCharacter
    public_class_method :new
    @@INITIAL_HEALTH=5

    def initialize( name, intelligence, strength)
      super(name, intelligence, strength, @@INITIAL_HEALTH)
    end

    def attack
      Dice.intensity(@strength)

    end


    def defend(receivedAttack)
      isDead=self.dead
      if(!isDead)
        defensiveEnergy=Dice.intensity(@intelligence)
        if(defensiveEnergy<receivedAttack)
          gotWounded
          isDead=dead
        end
      end
      isDead
    end
    def to_s
      "M" + super.to_s
    end

  end


end
