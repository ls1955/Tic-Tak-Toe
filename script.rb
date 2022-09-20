# frozen_string_literal: true

# The main event of game
class Game
  def initialize
    @board = Board.new
    @player1 = Player.new
    @player2 = Player.new('Player-2', 'X')
    @game_over = false
    @winner = nil
  end

  public
  def run_game
	  until @game_over
      column_index, row_index = prompt_user(@player1)
      next unless column_index.between?(0, 2) && row_index.between?(0, 2) && @board.layout[row_index][column_index] == ' '
      @player1.draw_point(@board, row_index, column_index)
      @board.render_board
      check_outcome(@board, @player1.draw_symbol, @player2.draw_symbol)
      break if @game_over
      column_index, row_index = prompt_user(@player2)
      next unless column_index.between?(0, 2) && row_index.between?(0, 2) && @board.layout[row_index][column_index] == ' '
      @player2.draw_point(@board, row_index, column_index)
      @board.render_board
      check_outcome(@board, @player1.draw_symbol, @player2.draw_symbol)
      break if @game_over
    end

    end_prompt
  end

  def start_prompt
    puts 'The game has began.'
    puts 'Choose a point by type in a number between 0 and 2.'
    puts "\n\n"
  end

  def end_prompt
    puts "Thank you for playing."
    puts "The winner is #{winner.name} || 'nobody'."
  end

  private
  attr_accessor :game_over, :winner

  def prompt_user(user)
    puts "#{user.name} please select a row."
    row_index = gets.to_i
    puts "#{user.name} please select a column."
    column_index = gets.to_i
    [column_index, row_index]
  end

  def check_outcome(board, symbol1, symbol2)
    board.layout.each do |row|
      if row.all?(symbol1)
        @game_over = true
        @winner = @player1
      elsif row.all?(symbol2)
        @game_over = true
        @winner = @player2
      end
    end

    if board.layout[0][0] == board.layout[1][1] && board.layout[1][1] == board.layout[2][2] && board.layout[0][0] != ' '
      if board.layout[0][0] == symbol1
        @winner = @player1
      else
        @winner = @player2
      end
      @game_over = true
    elsif board.layout[2][0] == board.layout[1][1] && board.layout[1][1] == board.layout[0][2] && board.layout[2][0] != ' '
      if board.layout[2][0] == symbol1
        @winner = @player1
      else
        @winner = @player2
      end
      @game_over = true
    end

    @game_over = true unless board.layout.flatten.include?(' ')
  end
end

# The board where the marks are drawn
class Board
  def initialize
    @layout = Array.new(3) { Array.new(3, ' ') }
  end

  def render_board
    puts "\n"
    @layout.each { |row| p row }
    puts "\n"
  end

  attr_accessor :layout
end

# User who could insert point on board
class Player
  attr_reader :name, :draw_symbol

  def initialize(name = 'Player-1', draw_symbol = 'O')
    @name = name
    @draw_symbol = draw_symbol
  end

  def draw_point(board, row_index, column_index)
    board.layout[row_index][column_index] = @draw_symbol
  end
end

game = Game.new
game.start_prompt
game.run_game
