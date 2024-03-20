# frozen_string_literal: true
module Irrgarten
  class CombatElement
    private_class_method :new
    def initialize(_effect ,_uses)

      @effect=_effect
      @uses=_uses
    end

    def produceEffect

      effect=0.0
      if @uses>0
        @uses-=1
        effect = @effect
      end
      effect
    end

    def discard

      Dice.discardElement(@uses)
    end

    def toString
      cadena= "[" + @effect + "," + @uses + "]"
      cadena
    end

  end
end
