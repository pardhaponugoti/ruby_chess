require "colorize"
require_relative "board"
require_relative "cursorable"

class Display
  include Cursorable

  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
  end

  def build_grid
    @board.grid.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :green
    elsif (i + j).odd?
      bg = :red
    else
      bg = :black
    end
    { background: bg, color: :white }
  end

  def render
    system("clear")
    build_grid.each { |row| puts row.join }
    nil
  end
end

if __FILE__ != $PROGRAM_NAME
  b = Board.new
  d = Display.new(b)
  d.render
end
