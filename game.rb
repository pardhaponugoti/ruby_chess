#!/usr/bin/env ruby

require_relative 'display'

class Game
  attr_accessor :display, :error_message
  attr_reader :board, :players

  def initialize(players)
    @board = Board.new
    @display = Display.new(@board)
    @players = players.shuffle
    @players[0].color = :white
    @players[1].color = :black
    @current_player = @players[0]
    @error_message = ''
  end

  def play
    until @board.checkmate?(@current_player.color)
      @error_message = ''
      @error_message ='You are in check!' if @board.in_check?(@current_player.color)
      begin
        @display.render
        puts @error_message
        @board.move(*@current_player.play_turn(@display))
      rescue => error
        @error_message = error.message
        retry
      end
      switch!
    end
    switch!
    @display.render
    puts "Game over! #{@current_player.name} is the winner!!"
  end

  def switch!
    @current_player = players.reject { |player| player == @current_player }.first
  end
end

class HumanPlayer
  attr_accessor :color
  attr_reader :name

  def initialize(name = "Current Player")
    @name = name
  end

  def play_turn(display)
    puts "#{@name} enter the position of the piece you want to move"
    start_pos = display.get_input
    display.selected = true if display.board[start_pos].color == @color
    display.selected_position = start_pos
    display.render
    puts "#{@name} enter the position where you want to move"
    end_pos = display.get_input
    display.selected = false
    [start_pos, end_pos, color]
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new([HumanPlayer.new("Player 1"), HumanPlayer.new("Player 2")])
  game.play
end
