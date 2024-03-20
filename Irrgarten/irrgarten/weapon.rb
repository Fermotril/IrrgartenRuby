# frozen_string_literal: true
module Irrgarten
  require_relative 'dice'
  require_relative 'combat_element'
  class Weapon < CombatElement
    public_class_method :new

    def attack

      produceEffect
    end
    def to_s
      cadena= "W[" +@power + ',' + @uses + ']'
      cadena
    end

  end
end
