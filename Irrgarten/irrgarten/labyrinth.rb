# frozen_string_literal: true
module Irrgarten

  require_relative 'dice'
  require_relative 'directions'
  require_relative 'orientation'

  class Labyrinth
    @@BLOCK_CHAR = 'X'
    @@EMPTY_CHAR = '-'
    @@MONSTER_CHAR  = 'M'
    @@COMBAT_CHAR= 'C'
    @@EXIT_CHAR = 'E'
    @@ROW = 0
    @@COL=1
    def initialize(nRows, nCols, exitRow, exitCol)
      @nRows=nRows
      @nCols=nCols
      @exitRow=exitRow
      @exitCol= exitCol
      @monsters=Array.new(@nRows){Array.new(@nCols, nil)}
      @players=Array.new(@nRows){Array.new(@nCols, nil)}
      @labyrinth=Array.new(@nRows){Array.new(@nCols, @@EMPTY_CHAR)}
      @labyrinth[exitRow][exitCol]=@@EXIT_CHAR


    end
    def setFuzzy(resucitado,antiguo)
      updateOldPos(antiguo.row, antiguo.col)
      putPlayer2D(antiguo.row,antiguo.col, resucitado.row, resucitado.col, resucitado)

    end

    def haveAWinner
      winner = false
      if @players[@exitRow][@exitCol]!= nil
        winner=true
      end

      winner
    end
    def to_s
      cadena="Matriz del juego \n"
      @labyrinth.each_with_index do |c,cindex|
        c.each_with_index do |r, rindex|
          cadena+= @labyrinth[cindex][rindex].to_s
        end
        cadena+="\n"

      end


      cadena
    end
    def addMonster( row, col, monster)

      if(@labyrinth[row][col]== @@EMPTY_CHAR)

        @monsters[row][col]=monster
        if @players[row][col]==nil

          @labyrinth[row][col]=@@MONSTER_CHAR
        else
          @labyrinth[row][col]=@@COMBAT_CHAR
        end

      end
    end


    def addBlock(orientation,startRow,startCol, length)
        if orientation == Orientation::VERTICAL
          incRow=1
          incCol=0
        else
          incRow=0
          incCol=1
        end
        row=startRow
        col=startCol
        while(posOK(row,col) && emptyPos(row,col) && length>0)
          @labyrinth[row][col]=@@BLOCK_CHAR
          length=-1
          row+=incRow
          col+=incCol
        end
    end
      def putPlayer(direction,player)
        oldRow=player.get_row
        oldCol=player.get_col
        newPos=dir2Pos(oldRow,oldCol,direction)
        monster=putPlayer2D(oldRow,oldCol,newPos[@@ROW],newPos[@@COL], player)
        monster
      end
      def spreadPlayers(players)
        players.each do |player|

          pos=randomEmptyPos
          putPlayer2D(-1,-1,pos[@@ROW],pos[@@COL], player)
        end
      end
      def validMoves(row,col)
        output=Array.new
        if(canStepOn(row+1, col))
          output.push(Directions::DOWN)
        end
        if(canStepOn(row-1, col))
          output.push(Directions::UP)
        end
        if(canStepOn(row, col+1))
          output.push(Directions::RIGHT)
        end
        if(canStepOn(row, col-1))
          output.push(Directions::LEFT)
        end
        output
      end
    private
    def posOK(row, col)
      (0<=row && @nRows>row && 0<= col && col<@nCols)
    end
    def emptyPos(row, col)
      vacio=false
      if(posOK(row, col))
          vacio=( @labyrinth[row][col]==@@EMPTY_CHAR )
      end

      vacio
    end
    def monsterPos(row, col)
      vacio=false
        if(posOK(row, col))
          vacio=( @labyrinth[row][col]==@@MONSTER_CHAR )
        end
        vacio
    end
    def exitPos(row, col)
        (row==@exitRow && col==@exitCol)
    end

      def combatPos(row, col)
        vacio=false
        if(posOK(row, col))
          vacio=( @labyrinth[row][col]==@@COMBAT_CHAR )
        end
        vacio
      end

      def canStepOn(row, col)
        (posOK(row, col) && (emptyPos(row, col) || monsterPos(row, col) || exitPos(row, col)))
      end

      def updateOldPos(row, col)
        if(posOK(row, col))
          if(@labyrinth[row][col]==@@COMBAT_CHAR)
            @labyrinth[row][col]=@@MONSTER_CHAR
          else
            @labyrinth[row][col]=@@EMPTY_CHAR
          end
        end
      end
      def dir2Pos(row, col, direction)
        nuevo=Array.new
        if(direction==Directions::LEFT)
          col-=1
        else if(direction==Directions::RIGHT)
               col+=1
               else if (direction==Directions::UP)
                      row-=1
                    else if (direction==Directions::DOWN)
                      row+=1
                    end
             end
             end
        end
        nuevo.push(row)
        nuevo.push(col)
        nuevo
      end

      def randomEmptyPos
          row=Dice.RandomPos(@nRows)
          col=Dice.RandomPos(@nCols)
          while !(emptyPos(row, col))
            row=Dice.RandomPos(@nRows)
            col=Dice.RandomPos(@nCols)
          end
          nuevo=Array.new
          nuevo.push(row)
          nuevo.push(col)
          nuevo

      end

      def putPlayer2D(oldRow, oldCol, row, col, player)
        output=nil
        if(canStepOn(row,col))
          if(posOK(oldRow,oldCol))
            p=@players[oldRow][oldCol]
            if(p==player)
              updateOldPos(oldRow, oldCol)
              @players[oldRow][oldCol]=nil
            end
          end
          monsterPos=monsterPos(row,col)
          if(monsterPos)
            @labyrinth[row][col]=@@COMBAT_CHAR
            output=@monsters[row][col]
          else
            number=player.getNumber
            @labyrinth[row][col]=number
          end
          @players[row][col]=player
          player.setPos(row,col)
        end
        output
      end
  end
end




