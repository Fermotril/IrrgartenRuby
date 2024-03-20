# frozen_string_literal: true
module Irrgarten
  class GameState
    attr_accessor :log
    attr_accessor :labyrinthv, :monsters, :players
    def initialize(lab , p , m , c , w , _log)
      @labyrinthv = lab
      @players = p
      @monsters = m
      @current_player = c
      @winner = w
      @log = _log
    end

  end
end
