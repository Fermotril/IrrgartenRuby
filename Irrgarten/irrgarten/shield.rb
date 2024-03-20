# frozen_string_literal: true
module Irrgarten
  require_relative 'combat_element'
  class Shield < CombatElement
    public_class_method :new

    def protect
      produceEffect
    end
    def to_s
      cadena= "S[" +@protection + ',' + @uses + ']'
      cadena
    end

  end
end
