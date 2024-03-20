# frozen_string_literal: true
module Irrgarten
  require_relative 'player'
  require_relative 'labyrinth'
  require_relative 'orientation'
  require_relative 'game_state'
  require_relative 'monster'
  require_relative 'game_character'
  class Game

    @@MAX_ROUNDS = 10
    def initialize(nplayers)

        @current_player_index =Dice.whoStart(nplayers)

      @log=""
      @monsters=Array.new
      @players=Array.new

      for i in 0..nplayers-1
        player=Player.new(i,Dice.randomIntelligence, Dice.randomStrength)
        @players.push(player)
      end
      @current_player= @players.at(@current_player_index)
      @labyrinth=Labyrinth.new(7,7,6,6)

      configure_labyrinth
      @labyrinth.spreadPlayers(@players)


    end

    def finished
        @labyrinth.haveAWinner

    end
    def get_game_state
      monstruos=""
      jugadores=""
      for i in 0.. @players.size
        jugadores+=@players.at(i).to_s
        jugadores+="\n"
      end

      for i in 0..@monsters.size
        monstruos+=@monsters.at(i).to_s
        monstruos+="\n"
      end

      nuevo =GameState.new(@labyrinth.to_s , jugadores, monstruos, @currentPlayerIndex ,finished , @log)

      nuevo
    end
    def next_step(preferredDirection)
      @log=""
      dead=@current_player.dead
      if dead==false
        direction=actual_direction(preferredDirection)
        if direction != preferredDirection
          logPlayerNoOrders
        end
        monster=@labyrinth.putPlayer(direction, @current_player)
        if monster==nil
          logNoMonster
        else
          winner=combat(monster)
          manageReward(winner)
        end
      else
        manageResurrection

      end
      end_game=finished
      if end_game==false
        next_player
      end
      end_game

    end
    private
    def configure_labyrinth
      monster=Monster.new("monstruo", Dice.randomIntelligence, Dice.randomStrength)
      @labyrinth.addMonster(3,3,monster)
      @monsters.push(monster)
      @labyrinth.addBlock(Orientation::VERTICAL,1,1,1)

    end
    def next_player
      if(@players.size!=1)
        @current_player_index=(@current_player_index+1)%@players.size
        @current_player = @players[@current_player_index]
      end
    end
    def log_player_won
      @log+="ha ganado el combate el jugador" + @current_player.to_s + "\n"
    end

    def actual_direction(preferred_directions)
      current_row=@current_player.get_row
      current_col=@current_player.get_col
      validMoves=@labyrinth.validMoves(current_row, current_col)
      output=@current_player.move(preferred_directions, validMoves)
      output
    end
    def combat(monster)
      rounds=0
      winner=GameCharacter::PLAYER
      playerAttack=@current_player.attack
      lose=monster.defend(playerAttack)
      while(!lose && rounds<@@MAX_ROUNDS)
        winner=GameCharacter::MONSTER
        rounds+=1
        monsterAttack=monster.attack
        lose=@current_player.defend(monsterAttack)
        if lose==false
          playerAttack=@current_player.attack
          lose=monster.defend(playerAttack)
          winner=GameCharacter::PLAYER


        end
      end
      logRounds(rounds,@@MAX_ROUNDS)
      winner
    end
    def manageResurrection
      resurrect=Dice.resurrectPLayer
      if(resurrect)
        @current_player.resurrect
        resucitado=FuzzyPlayer.new(@current_player)
        indice =@current_player_index
        @players[indice] = resucitado
        @labyrinth.setFuzzy(resucitado,@current_player)
        logResurrected
      else
        logPlayerSkipTurn
      end
    end
    def manageReward(winner)
      if(winner==GameCharacter::PLAYER)
        @current_player.receiveReward
        log_player_won
      else
        logMonsterWon
      end
    end
    def logMonsterWon
      @log+="ha ganado el combate el monstruo . \n"

    end

    def logResurrected
      @log+="Has resucitado . \n"

    end
    def logPlayerSkipTurn
      @log+="El jugador ha perdido el turno por estar muerto. \n"

    end
    def logPlayerNoOrders
      @log+="NO HAS SEGUIDO LAS NORMAS. \n"

    end
    def logNoMonster
      @log+="Te has movido a una celda vacia o no has podido avanzar . \n"

    end
    def logRounds(rounds,max)
      @log += "Ya se han jugado #{rounds} del maximo de #{max}\n" ;

    end
  end
end

