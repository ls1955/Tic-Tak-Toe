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

  def run_game
    until @game_over
      column_index, row_index = prompt_user(@player1)
      next unless valid?(row_index, column_index)

      process_turn(@player1, row_index, column_index)
      break if @game_over

      column_index, row_index = prompt_user(@player2)
      next unless valid?(row_index, column_index)

      process_turn(@player2, row_index, column_index)
      break if @game_over
    end
    print_outro
  end

  def print_intro
    puts 'The game has began.'
    puts 'Choose a point by type in a number between 0 and 2.'
    puts "\n\n"
  end

  def valid?(row, col)
    row.between?(0, 2) && col.between?(0, 2) && @board.layout[row][col] == ' '
  end

  def process_turn(player, row_index, column_index)
    player.draw_point(@board, row_index, column_index)
    @board.render_board
    check_outcome(@board, @player1.draw_symbol, @player2.draw_symbol)
  end

  def print_outro
    puts 'Thank you for playing.'
    puts @winner.nil? ? 'Tie game.' : "The winner is #{winner.name}."
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
    # check horizontal
    board.layout.each do |row|
      if row.all?(symbol1)
        @game_over = true
        @winner = @player1
      elsif row.all?(symbol2)
        @game_over = true
        @winner = @player2
      end
    end

    # check vertical and slope
    slot = board.layout
    if slot[0][0] == slot[1][1] && slot[1][1] == slot[2][2] && slot[0][0] != ' '
      @winner = slot[0][0] == symbol1 ? @player1 : player2
      @game_over = true
    elsif slot[2][0] == slot[1][1] && slot[1][1] == slot[0][2] && slot[2][0] != ' '
      @winner = slot[0][0] == symbol1 ? @player1 : player2
      @game_over = true
    elsif slot[0][0] == slot[1][0] && slot[1][0] == slot[2][0] && slot[0][0] != ' '
      @winner = slot[0][0] == symbol1 ? @player1 : player2
      @game_over = true
    elsif slot[0][1] == slot[1][1] && slot[1][1] == slot[2][1] && slot[0][1] != ' '
      @winner = slot[0][1] == symbol1 ? @player1 : player2
      @game_over = true
    elsif slot[0][2] == slot[1][2] && slot[1][2] == slot[2][2] && slot[0][2] != ' '
      @winner = slot[0][2] == symbol1 ? @player1 : player2
      @game_over = true
    end

    @game_over = true unless slot.flatten.include?(' ')
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
game.print_intro
game.run_game
