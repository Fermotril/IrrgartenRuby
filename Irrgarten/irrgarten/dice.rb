# frozen_string_literal: true
module Irrgarten
  class Dice
    @@MAX_USES = 5
    @@MAX_INTELLIGENCE = 10.0
    @@MAX_STRENGTH = 10.0
    @@RESURRECT_PROB = 0.3
    @@WEAPONS_REWARD = 2
    @@SHIELDS_REWARD = 3
    @@HEALTH_REWARD = 5
    @@MAX_ATTACK = 3
    @@MAX_SHIELD = 2
    @@generator = Random.new

    def self.RandomPos ( max )

      @@generator.rand( max + 1 )

    end
    def self.whoStart ( nplayers )

      @@generator.rand( nplayers  )

    end
    def self.randomIntelligence
      @@generator.rand * @@MAX_INTELLIGENCE

    end
    def self.randomStrength
      @@generator.rand * @@MAX_STRENGTH
    end
    def self.resurrectPLayer
      (@@generator.rand <= @@RESURRECT_PROB )

    end
    def self.weaponsReward
      @@generator.rand(@@WEAPONS_REWARD + 1 )

    end
    def self.shieldsReward
      @@generator.rand(@@SHIELDS_REWARD + 1 )

    end
    def self.healthReward
      @@generator.rand(@@HEALTH_REWARD + 1 )

    end
    def self.weaponPower
      @@generator.rand * @@MAX_ATTACK
    end

    def self.shieldPower
      @@generator.rand * @@MAX_SHIELD
    end
    def self.usesLeft
      @@MAX_USES * @@generator.rand
    end
    def self.intensity ( competence )
     (@@generator.rand * competence)

    end
    def self.discardElement( usesLeft )
      if usesLeft ==@@MAX_USES
        return false
      else
        if usesLeft == 0
          return true
        end
      end
      prob = 1 - (usesLeft / @@MAX_USES)
      (@@generator.rand <= prob)
    end
    def self.nextStep(preferred, validMoves, intelligence)
      random=randomIntelligence

      if random<=intelligence
        return preferred
      else
        index=(@@generator.rand * validMoves.size)
        return validMoves.at(index)

        end
    end
  end

end
