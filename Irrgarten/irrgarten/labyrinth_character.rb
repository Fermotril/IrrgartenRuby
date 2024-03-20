# frozen_string_literal: true
module Irrgarten
  class LabyrinthCharacter
    attr_reader :col, :row, :strength, :intelligence, :name
    attr_accessor :health
    private_class_method :new


    def initialize(_name , _intelligence, _strength, _health)
      @name =_name
      @intelligence=_intelligence
      @strength=_strength
      @health=_health
      @row=0
      @col=0
    end

    def copia(other)
      new(other.name, other.intelligence , other.strength, other.health)
      @row=other.row
      @col=other.col
    end


    def dead
      (!(@health>0))
    end

    def setPos(r, c)
      @row=r
      @col=c
    end


    def to_s
      cadena= " #{@name} [ #{@intelligence}, #{@health}, #{@strength}]"
      cadena
    end

    def gotWounded

      @health-=1
    end
  end


end

