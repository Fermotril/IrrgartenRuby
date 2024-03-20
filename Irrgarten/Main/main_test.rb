# frozen_string_literal: true
require_relative '../irrgarten/game'
require_relative '../UI/textUI'
require_relative '../Control/controller'

module Main
  class MainTest
    def self.main
      vista=UI::TextUI.new
      juego = Irrgarten::Game.new(1)
      controlador=Control::Controller.new(juego,vista)
      controlador.play
    end
  end
end

Main::MainTest.main