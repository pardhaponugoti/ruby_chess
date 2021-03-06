require_relative 'piece'

class Pawn < Piece
  attr_reader :initial_position
  attr_accessor :directions

  def initialize(color, position, board)
    super(color, position, board)
    @initial_position = position
    @directions = [[1,-1],[1,0],[1,1],[2,0]] if color == :black
    @directions = [[-1,-1],[-1,0],[-1,1],[-2,0]] if color == :white
  end

  def to_s
    return ' ♟  '.colorize(color: color)
  end

  #refactor moves for the pawn
  def moves
    output = []
    move_one = false
    @directions = @directions.take(3) if position != @initial_position
    directions.each_index do |index|
      possible_position = [position[0] + directions[index][0],position[1] + directions[index][1]]
      if index.even?
        if board.in_bounds?(possible_position) && occupied?(possible_position)
            output << possible_position unless board[possible_position].color == board[position].color
        end
      elsif index == 1
        if board.in_bounds?(possible_position) && !occupied?(possible_position)
            output << possible_position
            move_one = true
        end
      elsif board.in_bounds?(possible_position) && !occupied?(possible_position)
            output << possible_position if move_one
      end
    end
    output
  end

  def occupied?(pos)
    return true unless board[pos].color.nil?
    false
  end
end
