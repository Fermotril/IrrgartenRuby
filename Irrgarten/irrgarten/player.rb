# frozen_string_literal: true
module Irrgarten
  require_relative 'weapon'
  require_relative 'shield'
  require_relative 'labyrinth_character'
  class Player < LabyrinthCharacter
    public_class_method :new

    @@MAX_WEAPONS=2
    @@MAX_SHIELDS=3
    @@INITIAL_HEALTH=10
    @@HITS2LOSE=3

    def initialize(number, intelligence, strenght)
      super("jugador", intelligence, strenght, @@INITIAL_HEALTH)

      @number=number
      @consecutiveHits=0
      @weapons =Array.new
      @shields = Array.new
      for i in 0 .. @@MAX_WEAPONS
        @weapons[i] = newWeapon
      end

      for i in 0 .. @@MAX_SHIELDS
        @shields[i] = newShield
      end

    end
    def copia(other)
      super.copia(other)

      @number=other.number
      @consecutiveHits=0
      @weapons =Array.new
      @shields = Array.new
      for i in 0 .. @@MAX_WEAPONS
        @weapons[i] = newWeapon
      end

      for i in 0 .. @@MAX_SHIELDS
        @shields[i] = newShield
      end

    end
    def resurrect
      @weapons.clear
      @shields.clear
      @health=@@INITIAL_HEALTH
      @consecutiveHits=0
    end
    def setPos(row,col)
      @row=row
      @col=col
    end
    def getNumber
      @number
    end
    def getIntelligence
      @intelligence
    end
    def getStrenth
      @strength
    end
    def get_row
      @row
    end
    def get_col
      @col
    end

    def attack
      (@strength + sumWeapons)
    end
    def defend(receivedAttack)
      manageHit(receivedAttack)

    end


    def to_s
      "P" + super
    end
    def move( direction,validMoves)
      size=validMoves.size
      contained=validMoves.include?(direction)
      if size>0 && !contained
        firstElement=validMoves[0]
        return firstElement
      else
        return direction
      end
    end
    def receiveReward

      wReward=Dice.weaponsReward
      sReward=Dice.shieldsReward
      for i in 1..wReward
        wnew=newWeapon
        receiveWeapon(wnew)
      end
      for i in 1..sReward
        snew=newShield
        receiveShield(snew)
      end
      extraHealth=Dice.healthReward
      @health+=extraHealth

    end
    private
    def newWeapon
      nueva= Weapon.new(Dice.weaponPower, Dice.usesLeft)
      @weapons.push(nueva)
      nueva
    end
    def newShield
      nueva= Shield.new(Dice.shieldPower, Dice.usesLeft)
      @shields.push(nueva)
      nueva
    end
    def defensiveEnergy
      suma= @intelligence + sumShields
      suma
    end

    def resetHits
      @consecutiveHits=0
      end
    def gotWounded
      this.health-=1
    end

    def incConsecutiveHits
      @consecutiveHits+=1
    end

    def sumWeapons
      suma=0
      for i in 0 ... @weapons.size
        suma+=@weapons[i].attack
      end


      suma
    end

    def sumShields
      suma=0
      for shields in @shields
        suma+=shields.protect
      end

        suma
    end


    def receiveWeapon(w)
      for wi in @weapons
        discard=wi.discard
        if(discard)
          @weapons.delete(wi)

        end
      end
      size=@weapons.size
      if(size<@@MAX_WEAPONS)
        @weapons.delete(w)
      end
    end
    def receiveShield(s)
      for si in @shields
        discard=si.discard
        if(discard)
          @shields.delete(si)

        end
      end
      size=@shields.size
      if(size<@@MAX_SHIELDS)
        @shields.push(s)
      end
    end
    def manageHit(receivedAttack)
      defense=defensiveEnergy
      if(defense<receivedAttack)
        gotWounded
        incConsecutiveHits
      else
        resetHits
      end
      if(@consecutiveHits==@@HITS2LOSE || dead)
        resetHits
        lose=true
      else
        lose=false

      end
      lose
    end
  end
end
